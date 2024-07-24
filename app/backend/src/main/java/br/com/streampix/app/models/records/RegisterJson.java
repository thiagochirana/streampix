package br.com.streampix.app.models.records;

public record RegisterJson(
        String name,
        String username,
        String email,
        String password
) {
}
