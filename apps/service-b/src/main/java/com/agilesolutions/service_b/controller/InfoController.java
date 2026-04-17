package com.agilesolutions.service_b.controller;

import com.agilesolutions.service_b.model.ServiceInfo;
import com.agilesolutions.service_b.service.InfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/service-b")
@RequiredArgsConstructor
public class InfoController {

    private final InfoService infoService;

    @GetMapping(value = "/info")
    public ResponseEntity<ServiceInfo> getInfo() {
        return ResponseEntity.ok(infoService.getServiceInfo());
    }

}
