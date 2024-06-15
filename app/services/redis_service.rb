require "kredis"

class RedisService
  def self.get(key)
    redis_hash = Kredis.hash(key)
    redis_hash.to_h.transform_keys(&:to_sym)
  end

  def self.put(key, hash_obj, exp_time = nil)
    redis_hash = Kredis.hash(key)

    # Define o tempo de expiração se exp_time estiver especificado e for um número válido
    if exp_time && exp_time.is_a?(Numeric) && exp_time.positive?
      redis_hash.expire(exp_time)
    end
  end
end
