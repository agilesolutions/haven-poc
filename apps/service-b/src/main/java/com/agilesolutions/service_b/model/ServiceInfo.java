package com.agilesolutions.service_b.model;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "application.info")
@Data
public class ServiceInfo {

    private String name;
    private String version;
    private String description;
}
