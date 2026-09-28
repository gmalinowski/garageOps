class PanelController < ApplicationController
  include Pundit::Authorization

  before_action :authenticate_user!
  after_action :verify_pundit_authorization

  layout "panel"

  private

  def verify_pundit_authorization
    if action_name == "index"
      verify_policy_scoped
    else
      verify_authorized
    end
  end
end
