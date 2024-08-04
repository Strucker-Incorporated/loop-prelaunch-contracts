package com.energybox.backendcodingchallenge.service;

import com.energybox.backendcodingchallenge.domain.Gateway;
import com.energybox.backendcodingchallenge.repository.GatewayRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GatewayService {

    private final GatewayRepository repository;

    public GatewayService(GatewayRepository repository) {
        this.repository = repository;
    }

    public Gateway createGateway(Gateway gateway) {
        return repository.save(gateway);
    }

    public List<Gateway> getAllGateways() {
        return repository.findAll();
    }
}
