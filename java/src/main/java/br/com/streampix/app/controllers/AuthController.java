package br.com.streampix.app.controllers;

import br.com.streampix.app.models.records.AuthResponseJson;
import br.com.streampix.app.models.records.LoginJson;
import br.com.streampix.app.models.records.RegisterJson;
import br.com.streampix.app.services.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService service;

    @PostMapping("/sign_up")
    public ResponseEntity<AuthResponseJson> register(
            @RequestBody RegisterJson request
    ) {
        return service.register(request);
    }
    @PostMapping("/login")
    public ResponseEntity<AuthResponseJson> authenticate(
            @RequestBody LoginJson request
    ) {
        return service.authenticate(request);
    }

    @DeleteMapping("/logout")
    public ResponseEntity<AuthResponseJson> logout(){
        return service.destroySession();
    }

    @PostMapping("/refresh_token")
    public void refreshToken(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        service.refreshToken(request, response);
    }
}
