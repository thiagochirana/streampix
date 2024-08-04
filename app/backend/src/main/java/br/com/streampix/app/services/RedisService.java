package br.com.streampix.app.services;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
public class RedisService {

    private final RedisTemplate<String, String> redisTemplate;
    private final ObjectMapper objectMapper;

    public <T> void put(String key, T model) throws JsonProcessingException {
        String modelJson = objectMapper.writeValueAsString(model);
        redisTemplate.opsForValue().set(key, modelJson);
    }

    public <T> void put(String key, T model, int secondsToExpire) throws JsonProcessingException {
        String modelJson = objectMapper.writeValueAsString(model);
        redisTemplate.opsForValue().set(key, modelJson, secondsToExpire, TimeUnit.SECONDS);
    }

    public <T> T get(String key, Class<T> clazz) throws JsonProcessingException {
        String modelJson = redisTemplate.opsForValue().get(key);
        if (modelJson != null) {
            return objectMapper.readValue(modelJson, clazz);
        } else {
            return null;
        }
    }

    public <T> List<T> findByAttribute(String prefixKey, String attributeName, String attributeValue, Class<T> clazz) throws JsonProcessingException, JsonMappingException {
        List<T> models = new ArrayList<>();
        for (String key : Objects.requireNonNull(redisTemplate.keys(prefixKey + "*"))) {
            String modelJson = redisTemplate.opsForValue().get(key);
            if (modelJson != null) {
                T model = objectMapper.readValue(modelJson, clazz);
                String attributeJsonValue = objectMapper.convertValue(model, Map.class).get(attributeName).toString();
                if (attributeValue.equals(attributeJsonValue)) {
                    models.add(model);
                }
            }
        }
        return models;
    }
}