package me.bigfanoftim.weighted.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
public class WeightedRoutingController {

    @GetMapping("/weighted-routing")
    public void routing() {
        log.info("Received a request.");
    }
}
