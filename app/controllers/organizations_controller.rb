class OrganizationsController < PanelController
  def index
    @organizations = policy_scope(Organization).order(:name)
  end

  def show
    @organization = policy_scope(Organization).find_by!(slug: params[:slug])
    authorize @organization
  end

  def new
    @organization = authorize Organization.new
  end

  def create
    @organization = authorize Organization.new(organization_params)

    created = ActiveRecord::Base.transaction do
      unless @organization.save
        raise ActiveRecord::Rollback
      end

      Membership.create!(organization: @organization, user: current_user)
      true
    end

    if created
      redirect_to dashboard_path, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.expect(organization: [
      :name,
      :description,
      :email,
      :phone,
      :website,
      :tax_id,
      :country_code,
      :address_line_1,
      :address_line_2,
      :city,
      :postal_code
    ])
  end
end
