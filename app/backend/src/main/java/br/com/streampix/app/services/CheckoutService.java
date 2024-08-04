package br.com.streampix.app.services;

import br.com.streampix.app.models.checkout.Checkout;
import br.com.streampix.app.models.records.checkout.CheckoutJson;
import br.com.streampix.app.repositories.CheckoutRepositoryRedis;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CheckoutService {

    private final CheckoutRepositoryRedis checkoutRepositoryRedis;
    private final RedisService redis;

    public ResponseEntity doCheckout(CheckoutJson json) throws JsonProcessingException {
        Checkout checkout = new Checkout(null, json.nickname(), json.message(), json.value(), "100");
        redis.put("CO_"+json.nickname(), checkout);
        return ResponseEntity.ok().body("Deu bom em por no Redis");
    }

    public ResponseEntity getRedis(String nickname) throws JsonProcessingException {
        List<Checkout> checkouts = redis.findByAttribute("CO_"+nickname, "nickname", nickname, Checkout.class);
        if (checkouts.isEmpty()) {
            return ResponseEntity.notFound().build();
        } else {
            return ResponseEntity.ok(checkouts);
        }
    }
}