package br.com.streampix.app.repositories;

import br.com.streampix.app.models.checkout.Checkout;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CheckoutRepositoryRedis extends CrudRepository<Checkout, Long> {
    Optional<Checkout> findByNickname(String nickname);
}