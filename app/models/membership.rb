class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum :status, {
    active: "active",
    suspended: "suspended"
  }, validate: true

  validates :user, uniqueness: { scope: :organization }
end
