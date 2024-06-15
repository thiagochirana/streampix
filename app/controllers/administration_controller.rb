class AdministrationController < ApplicationController
  def get_credentials
    @credentials = EfipayService.get_access_token
  end
end
