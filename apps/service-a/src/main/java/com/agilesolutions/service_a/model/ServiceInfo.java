package com.agilesolutions.service_a.model;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "service")
@Data
public class ServiceInfo {

    private String name;
    private String version;
    private String description;
}
