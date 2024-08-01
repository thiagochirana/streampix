package br.com.streampix.app.controllers;

import br.com.streampix.app.models.records.checkout.CheckoutJson;
import br.com.streampix.app.services.CheckoutService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/checkout")
@RequiredArgsConstructor
public class CheckoutController {

    private final CheckoutService checkoutService;

    @PostMapping
    public ResponseEntity doCheckout(@RequestBody CheckoutJson json){
        return checkoutService.doCheckout(json);
    }
}