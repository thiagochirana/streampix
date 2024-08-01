package br.com.streampix.app.services;

import br.com.streampix.app.models.checkout.Checkout;
import br.com.streampix.app.models.records.checkout.CheckoutJson;
import br.com.streampix.app.repositories.CheckoutRepositoryRedis;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CheckoutService {

    private final CheckoutRepositoryRedis checkoutRepositoryRedis;

    public ResponseEntity doCheckout(CheckoutJson json){
        Checkout checkout = new Checkout(null, json.nickname(), json.message(), json.value(), "100");
        Checkout co = checkoutRepositoryRedis.save(checkout);
        return ResponseEntity.ok().body("Deu bom rapaziada ===> " + co.toString());
    }
}