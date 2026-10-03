class Permission < ApplicationRecord
  has_many :membership_permissions, dependent: :destroy
  has_many :memberships, through: :membership_permissions
  validates :key, presence: true, length: { minimum: 3, maximum: 128 }, uniqueness: true
  validates :name, presence: true, length: { minimum: 5, maximum: 256 }, uniqueness: true
  validates :description, length: { maximum: 1024 }

  normalizes :key, with: ->(value) { value.downcase.strip }
  normalizes :name, :description, with: ->(value) { value.strip }
end
