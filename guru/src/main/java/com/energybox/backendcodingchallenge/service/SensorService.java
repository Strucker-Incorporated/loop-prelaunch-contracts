package com.energybox.backendcodingchallenge.service;

import com.energybox.backendcodingchallenge.domain.Sensor;
import com.energybox.backendcodingchallenge.repository.SensorRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SensorService {

    private final SensorRepository repository;

    public SensorService(SensorRepository repository) {
        this.repository = repository;
    }

    public Sensor createSensor(Sensor sensor) {
        return repository.save(sensor);
    }

    public List<Sensor> getAllSensors() {
        return repository.findAll();
    }

    public List<Sensor> getSensorsByType(String type) {
        return repository.findByType(type);
    }

    public List<Sensor.LastReading> getLastReadings(Long sensorId) {
        Sensor sensor = repository.findById(sensorId).orElseThrow();
        return List.copyOf(sensor.getLastReadings());
    }
}
