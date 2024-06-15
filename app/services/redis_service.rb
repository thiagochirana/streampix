require "kredis"
require "colorize"

class RedisService
  def self.get(key)
    get_key = Kredis.string key
    get_value = get_key.value

    puts "KREDIS >>> GET".magenta
    puts "KEY: > #{key}".magenta
    puts "VALUE: > #{get_value}".magenta
    puts "#{"=" * 10}".magenta

    get_value
  end

  def self.put(key, new_value, exp_time = nil)
    if exp_time && exp_time.is_a?(Numeric) && exp_time.positive?
      new_key = Kredis.string key, expires_in: exp_time
    else
      new_key = Kredis.string key
    end

    new_key.value = new_value

    puts "KREDIS >>> SET".magenta
    puts "KEY: > #{new_key}".magenta
    puts "VALUE: > #{new_value}".magenta
    puts "#{"=" * 10}".magenta
  end
end
