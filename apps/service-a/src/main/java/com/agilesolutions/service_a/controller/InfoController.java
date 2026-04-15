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

    @GetMapping(value = "/info")
    public ResponseEntity<ServiceInfo> getInfo() {

        ServiceInfo info = infoService.getExternalInfo();
        return ResponseEntity.ok(info);
    }

}
