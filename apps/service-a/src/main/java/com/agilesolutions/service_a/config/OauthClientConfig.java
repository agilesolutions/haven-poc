package com.agilesolutions.service_a.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientManager;
import org.springframework.security.oauth2.client.web.client.OAuth2ClientHttpRequestInterceptor;
import org.springframework.web.client.RestClient;

/**
 * With this configuration:
 * 1. Tokens are automatically attached to outgoing requests
 * 2. Expired tokens are auto-refreshed by Spring before the request is made
 * 3. No manual token handling in your business logic
 *
 */
@Configuration
public class OauthClientConfig {

    @Bean
    public RestClient restClient(OAuth2AuthorizedClientManager authorizedClientManager) {
        OAuth2ClientHttpRequestInterceptor requestInterceptor =
                new OAuth2ClientHttpRequestInterceptor(authorizedClientManager);

        // Set client registration ID resolver (defaults to "oauth2ClientContext")
        // Use "auth-server" to match your application.yml registration name
        requestInterceptor.setClientRegistrationIdResolver(request -> "service-a");

        return RestClient.builder().requestInterceptor(requestInterceptor).build();
    }

}