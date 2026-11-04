class HomeController < ApplicationController
  def index
    @services = Service.where(active: true).order(:name)
  end
end
