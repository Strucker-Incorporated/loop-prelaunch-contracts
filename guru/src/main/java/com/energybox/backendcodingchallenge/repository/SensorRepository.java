package com.energybox.backendcodingchallenge.repository;

import com.energybox.backendcodingchallenge.domain.Sensor;
import org.springframework.data.neo4j.repository.Neo4jRepository;

import java.util.List;

public interface SensorRepository extends Neo4jRepository<Sensor, Long> {
    List<Sensor> findByType(String type);
}
