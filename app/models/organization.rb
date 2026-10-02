class Organization < ApplicationRecord
  before_validation :set_slug, on: :create

  validates :name, presence: true, uniqueness: true, length: { in: 2..120 }
  validates :slug, presence: true, uniqueness: true, length: { maximum: 180 },
    format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
  validates :tax_id, uniqueness: true, allow_nil: true, length: { maximum: 32 }
  validates :description, length: { maximum: 5_000 }
  validates :email, email: true, allow_nil: true
  validates :website, length: { maximum: 3_000 }, allow_nil: true
  validates :phone, phone: true, allow_nil: true
  validates :address_line_1, :address_line_2, length: { maximum: 255 }
  validates :city, length: { maximum: 255 }
  validates :postal_code, length: { maximum: 32 }
  validates :country_code, inclusion: { in: ISO3166::Country.codes }, allow_nil: true
  validates :regon, length: { maximum: 14 }

  validate :website_must_be_http_url

  normalizes :description,
            :phone,
            :address_line_1,
            :address_line_2,
            :city,
            :postal_code,
            :regon,
            :website,
            with: ->(value) { value.strip.presence }

  normalizes :name, with: ->(value) { value.squish.presence }
  normalizes :email, with: ->(value) { value.strip.downcase.presence }
  normalizes :tax_id, with: ->(value) { value.strip.upcase.presence }
  normalizes :country_code, with: ->(value) { value.strip.upcase.presence }
  normalizes :slug, with: ->(value) { value.strip.downcase }

  has_many :memberships, dependent: :restrict_with_error
  has_many :users, through: :memberships

  has_many :locations, dependent: :restrict_with_error

  def to_param
    slug
  end

  private

  def website_must_be_http_url
    return if website.blank?
    uri = URI.parse(website)
    return if uri.is_a?(URI::HTTP) && uri.host.present?

    errors.add(:website, :invalid)
  rescue URI::InvalidURIError
    errors.add(:website, :invalid)
  end

  def set_slug
    return if name.blank? || !slug.nil?

    self.slug = name.parameterize

    while Organization.where(slug: slug).where.not(id: id).exists?
      self.slug = "#{name.parameterize}-#{SecureRandom.hex(3)}"
    end
  end
end
