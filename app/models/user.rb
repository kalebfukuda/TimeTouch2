class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :profiles
  has_one :profile, dependent: :destroy
  has_many :registers
  validates :email, presence: true, uniqueness: true

  def active_for_authentication?
    super && profile&.active?
  end
end
