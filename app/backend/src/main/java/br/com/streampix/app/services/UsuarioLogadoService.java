package br.com.streampix.app.services;

import br.com.streampix.app.models.users.Usuario;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UsuarioLogadoService {

    public Optional<Usuario> getUsuarioLogado() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof Usuario) {
            return Optional.of((Usuario) authentication.getPrincipal());
        } else {
            return Optional.empty();
        }
    }
}