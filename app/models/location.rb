class Location < ApplicationRecord
  belongs_to :organization

  before_validation :set_slug, on: :create

  validates :name, presence: true, length: { in: 3..120 }, uniqueness: { scope: :organization }
  validates :description, length: { maximum: 5_000 }
  validates :slug, presence: true, length: { in: 3..180 }, uniqueness: { scope: :organization },
    format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
  validates :phone, phone: true, presence: true
  validates :email, email: true, presence: true
  validates :address_line_1, presence: true, length: { maximum: 255 }
  validates :address_line_2, length: { maximum: 255 }, allow_nil: true
  validates :postal_code, presence: true, length: { maximum: 16 },
    format: { with: /\A[A-Za-z0-9][A-Za-z0-9 -]{0,15}\z/ }
  validates :city, presence: true, length: { maximum: 255 }
  validates :country_code, inclusion: { in: ISO3166::Country.codes }, presence: true

  normalizes :name, with: ->(value) { value.squish.presence }
  normalizes :description,
    :address_line_1,
    :address_line_2,
    :city,
    :phone,
    :postal_code,
    with: ->(value) { value.strip.presence }

  normalizes :email, with: ->(value) { value.strip.downcase.presence }
  normalizes :country_code,
    with: ->(value) { value.strip.upcase.presence }
  normalizes :slug, with: ->(value) { value.strip.downcase }

  def to_param
    slug
  end

  private

  def set_slug
    return if name.blank? || !slug.nil?

    self.slug = name.parameterize

    while Location.where(organization_id: organization_id, slug: slug).where.not(id: id).exists?
      self.slug = "#{name.parameterize}-#{SecureRandom.hex(3)}"
    end
  end
end
