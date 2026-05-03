package com.agilesolutions.service_b.service;

import com.agilesolutions.service_b.model.InfoEntity;
import com.agilesolutions.service_b.model.ServiceInfo;
import com.agilesolutions.service_b.repository.InfoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class InfoService {

    private final ServiceInfo serviceInfo;

    private final InfoRepository repo;

    public Optional<InfoEntity> getInfo(String name) {
        return repo.findById(name);
    }

    @Transactional
    public InfoEntity upsert(InfoEntity entity) {
        entity.setUpdatedAt(OffsetDateTime.now());
        return repo.save(entity);
    }



}
