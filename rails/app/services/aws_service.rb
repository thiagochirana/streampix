require "aws-sdk"
require "dotenv/load"

class AwsService
  def self.credentials
    return Aws::Credentials.new(ENV.fetch("AWS_ACCESS_KEY_ID"),
                                ENV.fetch("AWS_SECRET_ACCESS_KEY"),
                                ENV.fetch("AWS_REGION"))
  end
end
