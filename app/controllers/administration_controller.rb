require "byebug"
require "mp3info"
require "colorize"

class AdministrationController < ApplicationController
  before_action :authenticate_user!

  def index
    @title_page = "Admin"
  end

  def send_test_alert
    system("rm -rf don_audio*.mp3")

    file_path_audio = "money_soundfx"
    donate = Donate.new(id: 22, nickname: "DevCurumin",
                        message: "meu boi é o top",
                        value: 1023.45)

    params = {
      :name_donate => "donate_#{donate.id}",
      :msg => "#{donate[:message]}",
    }

    TtsService.text_to_speak params

    file_path_msg = "#{params[:name_donate]}"

    audio = gen_audio_donate(file_path_audio, file_path_msg, donate.id)

    puts "vou enviar o alerta de id #{donate.id}".magenta
    SendAlertToViewJob.set(wait: 4.seconds).perform_later(donate.id, donate.nickname, donate.value, donate.message , audio)

    flash.notice = "Alerta será enviado, verifique na rota"

    redirect_to admin_path
  end

  def get_credentials
    @credentials = EfipayService.get_access_token
  end

  def gen_audio_donate(sound_fx, msg_donate, id)
    system("rm -rf public/don_audio*.mp3")

    # system("ffmpeg -i public/#{sound_fx}.mp3 -ar 44100 -ac 2 -ab 128k -f mp3 public/#{sound_fx}_aux.mp3")
    system("ffmpeg -i public/tts_donate/#{msg_donate}.mp3 -ar 44100 -ac 2 -ab 128k -f mp3 public/tts_donate/#{msg_donate}_aux.mp3")

    system("ffmpeg -i \"concat:public/#{sound_fx}_aux.mp3|public/tts_donate/#{msg_donate}_aux.mp3\" -acodec copy public/don_audio_#{id}.mp3")

    system("rm -rf public/tts_donate/donate*.mp3")

    return "don_audio_#{id}.mp3"
  end
end
