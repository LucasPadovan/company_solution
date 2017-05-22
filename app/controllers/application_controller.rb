class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :default_information

  private

  def default_information
    @information = {
        title: t("titles.#{self.controller_name}")
    }
  end
end
