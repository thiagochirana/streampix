package br.com.streampix.app.services;

import br.com.streampix.app.models.checkout.Checkout;
import br.com.streampix.app.models.records.checkout.CheckoutJson;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CheckoutService {

    private final RedisService redis;
    private static final String PREFIX = "CO_";

    public ResponseEntity doCheckout(CheckoutJson json) throws JsonProcessingException {
        Checkout checkout = new Checkout(json.nickname(), json.message(), json.value(), "60");
        redis.put(PREFIX+json.nickname(), checkout, 60);
        return ResponseEntity.ok().body("Deu bom em por no Redis");
    }

    public ResponseEntity getRedis(String nickname) throws JsonProcessingException {
        List<Checkout> checkouts = redis.findByAttribute(PREFIX+nickname, "nickname", nickname, Checkout.class);
        if (checkouts.isEmpty()) {
            return ResponseEntity.status(404).body("Nada encontrado com o nickname \"" + nickname+"\"");
        } else {
            return ResponseEntity.ok(checkouts);
        }
    }
}