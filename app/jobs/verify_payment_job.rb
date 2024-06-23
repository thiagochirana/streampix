require "colorize"

class VerifyPaymentJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Realizarei uma request na API efipay para verificar pagamento".magenta
    EfipayService.consult_payment args.first
  end
end
