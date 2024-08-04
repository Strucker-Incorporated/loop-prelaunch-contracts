package com.energybox.backendcodingchallenge.domain;

import org.neo4j.ogm.annotation.NodeEntity;
import org.neo4j.ogm.annotation.Id;
import org.neo4j.ogm.annotation.Property;
import org.neo4j.ogm.annotation.Relationship;

import java.util.HashSet;
import java.util.Set;

@NodeEntity
public class Sensor {

    @Id
    private Long id;

    @Property(name = "type")
    private Set<String> types = new HashSet<>();

    @Relationship(type = "CONNECTED_TO", direction = Relationship.OUTGOING)
    private Gateway gateway;

    @Property(name = "last_reading")
    private Set<LastReading> lastReadings = new HashSet<>();

    public Sensor() {
        // Default constructor
    }

    public Sensor(Long id, Set<String> types) {
        this.id = id;
        this.types = types;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Set<String> getTypes() {
        return types;
    }

    public void setTypes(Set<String> types) {
        this.types = types;
    }

    public Gateway getGateway() {
        return gateway;
    }

    public void setGateway(Gateway gateway) {
        this.gateway = gateway;
    }

    public Set<LastReading> getLastReadings() {
        return lastReadings;
    }

    public void setLastReadings(Set<LastReading> lastReadings) {
        this.lastReadings = lastReadings;
    }

    public static class LastReading {
        private String timestamp;
        private Double value;

        public LastReading() {
        }

        public LastReading(String timestamp, Double value) {
            this.timestamp = timestamp;
            this.value = value;
        }

        public String getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(String timestamp) {
            this.timestamp = timestamp;
        }

        public Double getValue() {
            return value;
        }

        public void setValue(Double value) {
            this.value = value;
        }
    }
}
