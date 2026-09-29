class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :registerable, :confirmable

  has_many :memberships, dependent: :restrict_with_error
  has_many :organizations, through: :memberships
end
