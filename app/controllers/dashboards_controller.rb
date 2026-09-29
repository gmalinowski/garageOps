class DashboardsController < PanelController
  def show
    authorize :dashboard
  end
end
