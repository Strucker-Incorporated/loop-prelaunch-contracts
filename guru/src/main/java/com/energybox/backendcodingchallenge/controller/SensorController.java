package com.energybox.backendcodingchallenge.controller;

import com.energybox.backendcodingchallenge.domain.Sensor;
import com.energybox.backendcodingchallenge.service.SensorService;
import io.swagger.annotations.ApiOperation;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/sensors")
public class SensorController {

    private final SensorService service;

    public SensorController(SensorService service) {
        this.service = service;
    }

    @ApiOperation(value = "Create a sensor", response = Sensor.class)
    @RequestMapping(value = "", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Sensor> create(@RequestBody Sensor sensor) {
        Sensor createdSensor = service.createSensor(sensor);
        return new ResponseEntity<>(createdSensor, HttpStatus.CREATED);
    }

    @ApiOperation(value = "Get all sensors", response = List.class)
    @RequestMapping(value = "", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<Sensor>> getAllSensors() {
        List<Sensor> sensors = service.getAllSensors();
        return new ResponseEntity<>(sensors, HttpStatus.OK);
    }

    @ApiOperation(value = "Get sensors by type", response = List.class)
    @RequestMapping(value = "/type/{type}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<Sensor>> getSensorsByType(@PathVariable String type) {
        List<Sensor> sensors = service.getSensorsByType(type);
        return new ResponseEntity<>(sensors, HttpStatus.OK);
    }

    @ApiOperation(value = "Get last readings of a sensor", response = List.class)
    @RequestMapping(value = "/{id}/readings", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<Sensor.LastReading>> getLastReadings(@PathVariable Long id) {
        List<Sensor.LastReading> readings = service.getLastReadings(id);
        return new ResponseEntity<>(readings, HttpStatus.OK);
    }
}
