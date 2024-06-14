class DonatesController < ApplicationController
  def index
    @donate = Donate.new
  end

  def create
  end
end
