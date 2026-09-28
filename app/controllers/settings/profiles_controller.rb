class Settings::ProfilesController < Settings::BaseController
  def edit
    authorize :profile
  end
end
