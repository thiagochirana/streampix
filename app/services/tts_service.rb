require "aws-sdk-polly"

class TtsService
  def self.text_to_speak(speech_params)
    AwsService.credentials
    polly = Aws::Polly::Client.new

    resp = polly.synthesize_speech({
      output_format: "mp3",
      text: speech_params[:msg],
      voice_id: "Ricardo",
    })

    # resp = polly.describe_voices(language_code: "es-ES")

    # resp.voices.each do |v|
    #   puts v.name
    #   puts "  " + v.gender
    #   puts
    # end

    mp3_file = speech_params[:name_donate] + ".mp3"

    IO.copy_stream(resp.audio_stream, Rails.root.join("public", "tts_donate", mp3_file))
  end
end
