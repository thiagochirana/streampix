class AlertsController < ApplicationController
  before_action :title
  layout "empty"

  def show
  end

  def title
    @title_page = "Alerts"
  end
end
