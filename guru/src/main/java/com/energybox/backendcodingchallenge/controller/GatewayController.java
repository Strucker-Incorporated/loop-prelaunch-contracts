package com.energybox.backendcodingchallenge.controller;

import com.energybox.backendcodingchallenge.domain.Gateway;
import com.energybox.backendcodingchallenge.service.GatewayService;
import io.swagger.annotations.ApiOperation;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping(value = "/gateways")
public class GatewayController {

    private final GatewayService service;

    public GatewayController(GatewayService service) {
        this.service = service;
    }

    @ApiOperation(value = "Create a gateway", response = Gateway.class)
    @RequestMapping(value = "", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Gateway> create(@RequestBody Gateway gateway) throws IOException, InterruptedException {
        Gateway createdGateway = service.createGateway(gateway);
        return new ResponseEntity<>(createdGateway, HttpStatus.CREATED);
    }

    @ApiOperation(value = "Get all gateways", response = List.class)
    @RequestMapping(value = "", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<Gateway>> getAllGateways() {
        List<Gateway> gateways = service.getAllGateways();
        return new ResponseEntity<>(gateways, HttpStatus.OK);
    }
}
