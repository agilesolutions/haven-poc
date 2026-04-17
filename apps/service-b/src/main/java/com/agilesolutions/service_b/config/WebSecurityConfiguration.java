package com.agilesolutions.service_b.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.config.annotation.method.configuration.EnableReactiveMethodSecurity;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.NimbusReactiveJwtDecoder;
import org.springframework.security.oauth2.jwt.ReactiveJwtDecoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.ReactiveJwtAuthenticationConverterAdapter;
import org.springframework.security.web.server.SecurityWebFilterChain;

import java.util.Collection;
import java.util.stream.Collectors;

@Configuration
@EnableWebFluxSecurity
@EnableReactiveMethodSecurity
public class WebSecurityConfiguration {

    private static final String[] WHITELIST = {"/healthCheck",
            "/actuator/**",
            "/v3/api-docs/**",
            "/api/service-b/**",
            "/swagger-ui/**",
            "/swagger-ui.html"};

    @Bean
    SecurityWebFilterChain springWebFilterChain(ServerHttpSecurity http) {
        http
                .cors(c -> c.disable())
                .csrf(c -> c.disable())
                .authorizeExchange(exchanges -> exchanges
                        .pathMatchers(WHITELIST).permitAll()
                        .anyExchange().authenticated())
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwtSpec ->
                        jwtSpec.jwtDecoder(jwtDecoder(authorizationServerProperties)).
                                jwtAuthenticationConverter(jwtAuthenticationConverter())));
        return http.build();
    }

    @Bean
    public ReactiveJwtDecoder jwtDecoder(AuthorizationServerProperties authorizationServerProperties) {
        return NimbusReactiveJwtDecoder.withJwkSetUri(authorizationServerProperties.getUrl() + "/.well-known/jwks.json").build();
    }

    @Bean
    public Converter<Jwt, ? extends Mono<? extends AbstractAuthenticationToken>> jwtAuthenticationConverter() {
        return new ReactiveJwtAuthenticationConverterAdapter(jwt -> {
            JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
            converter.setJwtGrantedAuthoritiesConverter(this::extractAuthoritiesFromJwt);
            return converter.convert(jwt);
        });
    }

    private Collection<GrantedAuthority> extractAuthoritiesFromJwt(Jwt jwt) {
        // Map "roles" claim to ROLE_* authorities
        Collection<String> roles = jwt.getClaimAsStringList("roles");
        if (roles == null) {
            roles = java.util.Collections.emptyList();
        }
        return roles.stream()
                .map(role -> "ROLE_" + role.toUpperCase())
                .map(org.springframework.security.core.authority.SimpleGrantedAuthority::new)
                .collect(Collectors.toList());
    }


}