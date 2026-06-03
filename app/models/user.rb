class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :profiles
  has_one :profile, dependent: :destroy
  has_many :registers
  validates :email, presence: true, uniqueness: true
  has_one :contact, dependent: :destroy
  def active_for_authentication?
    super && profile&.active?
  end

  def name
    profile&.name
  end

  def line_contact?
    contact&.line_user_id.present?
  end
end
