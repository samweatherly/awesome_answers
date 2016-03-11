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

  # this enables us to store a Hash to the twitter_data field and retrieve it
  # as a Hash. Rails will take care of encoding/decoding the data of the Hash
  # to and from the database. It will be stored as Text in the database.
  serialize :twitter_data, Hash

  validates :password, length: {minimum: 6}, on: :create
  validates :first_name, presence: true
  validates :last_name, presence: true, unless: :from_oauth?
  validates :email, presence: true,
                    uniqueness: true,
                    format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
                    unless: :from_oauth?

  def from_oauth?
    uid.present? && provider.present?
  end

  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def signed_in_with_twitter?
    provider.present? && uid.present? && provider == "twitter" 
  end

  def self.find_twitter_user(omniauth_data)
    where(provider: "twitter", uid: omniauth_data["uid"]).first
  end

  def self.create_from_twitter(twitter_data)
    name = twitter_data['info']['name'].split(" ")
    # byebug
    user = User.create(provider: "twitter", uid: twitter_data["uid"],
                    first_name: name[0], last_name: name[1],
                    password: SecureRandom.hex,
                    twitter_token: twitter_data['credentials']['token'],
                    twitter_secret: twitter_data['credentials']['secret'],
                    twitter_raw_data: twitter_data)
  end


  # user = User.last
  # client = Twitter::REST::Client.new do |config|
  #   config.consumer_key        = ENV["twitter_consumer_key"]
  #   config.consumer_secret     = ENV['twitter_consumer_secret']
  #   config.access_token        = user.twitter_token
  #   config.access_token_secret = user.twitter_secret
  # end




  before_create :generate_api_key

  private

  def generate_api_key
    #ensure uniqueness in db
    begin
      self.api_key = SecureRandom.hex(32)
    end while User.exists?(api_key: self.api_key)
  end


end
