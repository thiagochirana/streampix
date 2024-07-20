require "colorize"

class RemoveAlertFromViewJob < ApplicationJob
  queue_as :default

  def perform(donate_id)
    Turbo::StreamsChannel.broadcast_remove_to(
      "alerts",
      target: "alert-#{donate_id}",
    )
    puts "removendo da view o donate #{donate_id} assim como o áudio donate".yellow
    Dir.glob("public/don_audio*.mp3").each { |file| File.delete(file) }
  end
end
