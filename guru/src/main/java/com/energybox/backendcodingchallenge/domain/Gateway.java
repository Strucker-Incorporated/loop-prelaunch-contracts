package com.energybox.backendcodingchallenge.domain;

import org.neo4j.ogm.annotation.NodeEntity;
import org.neo4j.ogm.annotation.Id;
import org.neo4j.ogm.annotation.Relationship;

import java.util.HashSet;
import java.util.Set;

@NodeEntity
public class Gateway {

    @Id
    private Long id;

    @Relationship(type = "CONNECTED_TO", direction = Relationship.INCOMING)
    private Set<Sensor> sensors = new HashSet<>();

    public Gateway() {
        // Default constructor
    }

    public Gateway(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Set<Sensor> getSensors() {
        return sensors;
    }

    public void setSensors(Set<Sensor> sensors) {
        this.sensors = sensors;
    }

    public void addSensor(Sensor sensor) {
        this.sensors.add(sensor);
    }
}
