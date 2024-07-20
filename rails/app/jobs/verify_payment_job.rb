require "colorize"
require "kredis"

class VerifyPaymentJob < ApplicationJob
  queue_as :default

  def perform(*args)
    donate = args.first
    status = EfipayService.consult_payment donate
    @file_path_audio = "/money_soundfx.mp3"

    if status.starts_with?("REMOVIDA")
      puts "Pagamento do donate foi cancelado".red
      donate.update(status: "cancelled")
    elsif status.starts_with?("CONCLUIDA")
      puts "Donate foi pago com sucesso".green
      donate.update(status: "paid", was_paid: true)

      Turbo::StreamsChannel.broadcast_append_to(
        "alerts",
        target: "alert-container",
        partial: "alerts/alert",
        locals: { donate_id: donate.id,
                  donate_nickname: donate.nickname,
                  donate_value: donate.value,
                  donate_msg: donate.msg,
                  file_path_audio: audio },
      )
    elsif status.starts_with?("ATIVA")
      puts "Donate ainda está em aberto, vou realizar nova request".yellow
      VerifyPaymentJob.set(wait: 10.seconds).perform_later donate
    end
  end
end
