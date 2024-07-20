require "colorize"

class SendAlertToViewJob < ApplicationJob
  queue_as :default

  def perform(id, nickname, value, msg, audio)
    unless File.exist?("public/#{audio}")
      puts "Audio para o donate #{id} não encontrado. Vou buscar em 2 segs novamente".red
      SendAlertToViewJob.set(wait: 2.seconds).perform_later(id, nickname, value, msg, audio)
    end
    puts "Enviando para a view o alerta de donate id #{id} | #{nickname}".green
    Turbo::StreamsChannel.broadcast_append_to(
      "alerts",
      target: "alert-container",
      partial: "alerts/alert",
      locals: { donate_id: id,
                donate_nickname: nickname,
                donate_value: value,
                donate_msg: msg,
                file_path_audio: audio },
    )

    puts "remover o donate #{id} em 10 segundos..."
    RemoveAlertFromViewJob.set(wait: 10.seconds).perform_later(id)
  end
end
