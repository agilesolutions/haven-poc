package com.agilesolutions.service_a.controller;

import com.agilesolutions.service_a.model.ServiceInfo;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/service-a")
@RequiredArgsConstructor
public class InfoController {

    @GetMapping(value = "/info", version = "1.0.0")
    public ResponseEntity<ServiceInfo> getInfo() {
        ServiceInfo info = new ServiceInfo();
        info.setName("Service A");
        info.setVersion("1.0.0");
        info.setDescription("This is Service A, providing account-related information.");
        return ResponseEntity.ok(info);
    }

}
