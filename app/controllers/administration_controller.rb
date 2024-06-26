require "ruby-audio"
require "byebug"

class AdministrationController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def send_test_alert
    @file_path_audio = "/money_soundfx.mp3"
    donate = Donate.new(id: 2, nickname: "DevCurumin", message: "teste de mensagem aqui",
                        value: 123.45)

    #reproduzir audio nesse stream
    Turbo::StreamsChannel.broadcast_append_to(
      "alerts",
      target: "alert-container",
      partial: "alerts/alert",
      locals: { donate: donate, file_path_audio: @file_path_audio },
    )
    flash.notice = "Alerta sendo enviado, verifique na rota"

    redirect_to admin_path
  end

  def get_credentials
    @credentials = EfipayService.get_access_token
  end
end
