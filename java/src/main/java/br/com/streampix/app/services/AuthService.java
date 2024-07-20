package br.com.streampix.app.services;

import br.com.streampix.app.models.records.AuthResponseJson;
import br.com.streampix.app.models.records.LoginJson;
import br.com.streampix.app.models.records.RegisterJson;
import br.com.streampix.app.models.tokens.Token;
import br.com.streampix.app.models.tokens.TokenType;
import br.com.streampix.app.models.users.Usuario;
import br.com.streampix.app.repositories.TokenRepository;
import br.com.streampix.app.repositories.UsuarioRepository;
import br.com.streampix.app.security.JwtService;
import br.com.streampix.app.utils.Logs;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UsuarioRepository repository;
    private final TokenRepository tokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final UsuarioLogadoService usuarioLogadoService;

    private Logs LOG = new Logs(AuthService.class);

    @Transactional
    public ResponseEntity<AuthResponseJson> register(RegisterJson json) {
        var user = Usuario.builder()
            .name(json.name())
            .username(json.username())
            .email(json.email())
            .password(passwordEncoder.encode(json.password()))
            .build();
        var savedUser = repository.save(user);
        var jwtToken = jwtService.generateToken(user);
        var refreshToken = jwtService.generateRefreshToken(user);
        saveUserToken(savedUser, jwtToken);
        return ResponseEntity.status(201).body(new AuthResponseJson(jwtToken, refreshToken, "Voce foi cadastrado com sucesso!"));
    }

    @Transactional
    public ResponseEntity<AuthResponseJson> authenticate(LoginJson request) {
        var user = repository.findByUsername(request.username());
        if (user.isEmpty()){
            LOG.warn("Usuario com username "+request.username()+" não foi encontrado");

            return ResponseEntity.status(401).body(new AuthResponseJson(
                    null,
                    null,
                    "Usuario "+request.username()+" não está cadastrado, por favor cadastre-se"
            ));
        }

        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                request.username(),
                request.password()
            )
        );
        var jwtToken = jwtService.generateToken(user.get());
        var refreshToken = jwtService.generateRefreshToken(user.get());
        revokeAllUserTokens(user.get());
        saveUserToken(user.get(), jwtToken);
        LOG.info("Usuario "+user.get().getName()+" autenticado com sucesso");
        return ResponseEntity.ok(new AuthResponseJson(jwtToken, refreshToken, "Usuário Logado com sucesso!"));
    }

    private void saveUserToken(Usuario user, String jwtToken) {
        var token = Token.builder()
            .user(user)
            .token(jwtToken)
            .tokenType(TokenType.BEARER)
            .expired(false)
            .revoked(false)
            .build();
        tokenRepository.save(token);
    }

    private void revokeAllUserTokens(Usuario user) {
        var validUserTokens = tokenRepository.findAllValidTokenByUser(user.getId());
        if (validUserTokens.isEmpty())
            return;
        validUserTokens.forEach(token -> {
            token.setExpired(true);
            token.setRevoked(true);
        });
        tokenRepository.saveAll(validUserTokens);
    }


    // TODO ajustar o refresh token
    @Transactional
    public void refreshToken(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws IOException {
        final String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        final String refreshToken;
        final String userEmail;
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return;
        }
        refreshToken = authHeader.substring(7);
        String username = jwtService.extractUsername(refreshToken);
        if (username != null) {
            var user = this.repository.findByUsername(username)
                    .orElseThrow();
            if (jwtService.isTokenValid(refreshToken, user)) {
                var accessToken = jwtService.generateToken(user);
                revokeAllUserTokens(user);
                saveUserToken(user, accessToken);
                var authResponse = new AuthResponseJson(
                    accessToken,
                    refreshToken,
                    "Autenticado com sucesso!"
                );
                new ObjectMapper().writeValue(response.getOutputStream(), authResponse);
            }
        }
    }

    public ResponseEntity<AuthResponseJson> destroySession(){
        var user = usuarioLogadoService.getUsuarioLogado();
        if (user.isPresent()) {
            List<Token> tokens = new ArrayList<>();
            for(Token t : tokenRepository.findAllValidTokenByUser(user.get().getId())){
                t.setExpired(true);
                t.setRevoked(true);
                tokens.add(t);
            }
            tokenRepository.saveAll(tokens);
        }
        return ResponseEntity.ok(new AuthResponseJson(null, null, "Você foi deslogado! Até mais!"));
    }

}