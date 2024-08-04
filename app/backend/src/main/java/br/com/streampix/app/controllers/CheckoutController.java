package br.com.streampix.app.controllers;

import br.com.streampix.app.models.GetRedis;
import br.com.streampix.app.models.records.checkout.CheckoutJson;
import br.com.streampix.app.services.CheckoutService;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/checkout")
@RequiredArgsConstructor
public class CheckoutController {

    private final CheckoutService checkoutService;

    @PostMapping
    public ResponseEntity doCheckout(@RequestBody CheckoutJson json) throws JsonProcessingException {
        return checkoutService.doCheckout(json);
    }

    @GetMapping
    public ResponseEntity getCheckout(@RequestBody GetRedis json) throws JsonProcessingException {
        return checkoutService.getRedis(json.nickname());
    }
}