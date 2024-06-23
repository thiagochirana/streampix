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
      redirect_to root_path, flash.alert = "não deu bom"
    end
  end

  def checkout
    @donate = Donate.find_by(id: params[:donate_id])
    data = EfipayService.gen_new_payment @donate
    # if data[:code_status] < 300
    qrcode = RQRCode::QRCode.new(data.pix_copia_cola)

    @qr_svg = qrcode.as_svg(
      color: "FFF",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true,
    )
    @pix_copia_cola = data.pix_copia_cola
    # else
    #   redirect_to root_path, alert: "#{data[:message]}"
    # end
  end

  def consult_payment
    @donate = Donate.find_by(id: params[:donate_id])
    @status = EfipayService.consult_payment @donate
  end

  def donate_params
    params.require(:donate).permit(:nickname, :message, :value)
  end
end
