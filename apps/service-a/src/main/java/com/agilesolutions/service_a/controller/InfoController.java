package com.agilesolutions.service_a.controller;

import com.agilesolutions.service_a.model.ServiceInfo;
import com.agilesolutions.service_a.service.InfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/service-a")
@RequiredArgsConstructor
public class InfoController {

    private final InfoService infoService;

    private final ServiceInfo serviceInfo;

    @GetMapping(value = "/remoteInfo")
    public ResponseEntity<ServiceInfo> getRemoteInfo() {

        ServiceInfo info = infoService.getExternalInfo();
        return ResponseEntity.ok(info);
    }

    @GetMapping(value = "/info")
    public ResponseEntity<ServiceInfo> getInfo() {
        return ResponseEntity.ok(serviceInfo);
    }


}
