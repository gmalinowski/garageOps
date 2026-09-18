class DashboardsController < ApplicationController
  before_action :authenticate_user!
  layout "panel"

  def show
  end
end
