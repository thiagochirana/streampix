require "rqrcode"

class DonatesController < ApplicationController
  def index
    @donate = Donate.new
  end

  def create
    @donate = Donate.new donate_params
    if @donate.save
      redirect_to donate_checkout_path(@donate)
    else
      redirect_to root_path , alert: "não deu bom"
    end
  end

  def checkout

    qrcode = RQRCode::QRCode.new("http://github.com/")

    @qr_svg = qrcode.as_svg(
      color: "FFF",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    )

  end

  def donate_params
    params.require(:donate).permit(:nickname, :message, :value)
  end

end
