package com.agilesolutions.service_b.controller;

import com.agilesolutions.service_b.model.InfoEntity;
import com.agilesolutions.service_b.model.ServiceInfo;
import com.agilesolutions.service_b.service.InfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/service-b")
@RequiredArgsConstructor
public class InfoController {

    private final InfoService infoService;

    @GetMapping("/info")
    public ResponseEntity<InfoEntity> getInfo() {
        return infoService.getInfo("default")
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/info")
    public ResponseEntity<InfoEntity> putInfo(@RequestBody InfoEntity payload) {
        if (payload.getName() == null || payload.getName().isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        InfoEntity saved = infoService.upsert(payload);
        return ResponseEntity.ok(saved);
    }
}
