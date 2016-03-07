class User < ActiveRecord::Base
  # attr_accessor :password
  # attr_accessor :password_confirmation
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  has_many :likes, dependent: :destroy
  has_many :liked_questions, through: :likes, source: :question

  has_many :favourites, dependent: :destroy
  has_many :favourite_questions, through: :favourites, source: :question

  has_many :votes, dependent: :destroy
  has_many :voted_questions, through: :votes, source: :question



  has_secure_password

  validates :password, length: {minimum: 6}, on: :create
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def full_name
    "#{first_name} #{last_name}".titleize
  end



end
