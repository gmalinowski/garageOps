class Membership < ApplicationRecord
  STATUSES = %w[active suspended].freeze

  belongs_to :user
  belongs_to :organization

  validates :status, inclusion: { in: STATUSES }

  validates :user, uniqueness: { scope: :organization }
end
