class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :tax_id, presence: true, uniqueness: true

  %i[email address_line_1 postal_code city country_code phone].each do |field|
    validates field, presence: true
  end

  has_many :memberships, dependent: :restrict_with_error
  has_many :users, through: :memberships
end
