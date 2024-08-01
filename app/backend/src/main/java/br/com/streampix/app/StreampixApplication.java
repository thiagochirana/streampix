package br.com.streampix.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.redis.repository.configuration.EnableRedisRepositories;

@SpringBootApplication
@EnableRedisRepositories
public class StreampixApplication {

	public static void main(String[] args) {
		SpringApplication.run(StreampixApplication.class, args);
	}

}