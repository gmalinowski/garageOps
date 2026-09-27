class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  def new
  @organization = Organization.new
  end
end
