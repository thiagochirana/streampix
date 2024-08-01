package br.com.streampix.app.models.records.checkout;

public record CheckoutJson(
        String nickname,
        String message,
        String value
) {
}