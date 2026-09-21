class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :memberships, dependent: :restrict_with_error
  has_many :users, through: :memberships
end
