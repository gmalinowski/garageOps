class MembershipPermission < ApplicationRecord
  belongs_to :location, optional: true
  belongs_to :membership
  belongs_to :organization
  belongs_to :permission

  before_validation :set_organization_from_membership, on: :create

  enum :scope_type, {
    organization: "organization",
    location: "location"
  }, prefix: :scope, validate: true

  validate :location_matches_scope
  validate :membership_must_belong_to_membership_organization
  validate :location_must_belong_to_membership_organization


  private

  def set_organization_from_membership
    self.organization = membership&.organization
  end

  def location_must_belong_to_membership_organization
    return if location.nil? || membership.nil?
    return if location.organization_id == organization.id

    errors.add(:location, :organization_mismatch)
  end

  def membership_must_belong_to_membership_organization
    return if location.nil? || membership.nil?
    return if membership.organization_id == organization.id

    errors.add(:membership, :organization_mismatch)
  end

  def location_matches_scope
    if scope_location? && location.nil?
      errors.add(:location, :required_for_location_scope)
    elsif scope_organization? && location.present?
      errors.add(:location, :must_be_blank_for_organization_scope)
    end
  end
end
