package br.com.streampix.app.models.records;

public record AuthResponseJson(
        String token,
        String refresh_token,
        String message
) {
}
