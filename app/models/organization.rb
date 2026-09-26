class Organization < ApplicationRecord
  before_validation :set_slug, on: :create
  normalizes :tax_id, with: ->(value) { value.strip.presence }

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :tax_id, uniqueness: true, allow_nil: true
  validates :country_code, inclusion: { in: ISO3166::Country.codes }, allow_blank: true

  has_many :memberships, dependent: :restrict_with_error
  has_many :users, through: :memberships

  private

  def set_slug
    self.slug ||= name.parameterize

    while Organization.where(slug: slug).where.not(id: id).exists?
      self.slug = "#{name.parameterize}-#{SecureRandom.hex(4)}"
    end
  end
end
