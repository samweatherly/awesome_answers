class Question < ActiveRecord::Base
  # this will fail validations (so it won't create or save) if the title
  #is not provided

  # This will establish a 'has_many' association with answers. This
  # assumes that your answer model has a 'question_id' integer field
  # that references the question. With 'has_many', 'answers' must be
  # pural (Rails convention).
  # We must pass a 'dependent' option to maintain data integrity. The
  # possible values you can give it are: :destroy or :nullify
  # With :destroy: if you delete a question it will delete all
  # associated answers.
  # With :nullify: if you delete a question it will update the
  # 'question_id' to be NULL for all associated records (no deletion)
  belongs_to :category
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes

  has_many :favourites, dependent: :destroy
  has_many :favourite_users, through: :favourites, source: :user

  # This enables us to access all the comments created for all the question's
  # answers. This generates a single SQL statement with 'INNER JOIN' to
  # accomplish it
  has_many :comments, through: :answers

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :votes, dependent: :destroy
  has_many :voting_users, through: :votes, source: :user



  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :title, length: {minimum: 3, maximum: 255}
  validates :title, exclusion: { in: %w(Microsoft Sony Apple)}


  # validates :title, presence: true

  # DSL: Domain Specific Language
  # The code we use in here is completely valid Ruby code but the
  # method naming and arguments are specific to ActiveRecord so we call this
  # an ActiveRecord DSL
  #validates (:body, {uniqueness: {message: "must be unique"}})
  validates :body, uniqueness: {message: "must be unique!"}

  # this validates that the combination of the title and the body
  # is unique. Which means the title doesn't have to be unique by itself
  # and the body doesn't have to be unique by itself. However, the
  # combinatino of the two fields must be unique.
  #validates :title, uniqueness: {scope: :body}

  validates :view_count, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1000}

  # validates :count_sale, numericality: {less_than_or_equal_to: :view_count}


  # custom validation method, singluar instead of plural
  # We must make sure that 'no_monkey' is a method available for our
  # class. The method can be public or private. It's more likely we
  # will have it as a a private method because we don't need to use
  # it outside this class.
  validate :no_monkey

  after_initialize :set_defaults
  before_save :capitalize_title

  # scope :recent, lambda{ |x| order("created_at DESC").limit(x) }
  def self.recent(number = 5)
    order("created_at DESC").limit(number)
  end

  def vote_for(user)
    votes.find_by_user_id user
  end

  def vote_result()
    #up_count and down_count in vote.rb
    votes.up_count - votes.down_count
  end

  def self.popular
    where("view_count > 10")
  end

  # Wildcard search by title or body
  # ordered by view_count in a descending order
  def self.search(term)
    where(["title ILIKE ? OR body ILIKE ?", "%#{term}%", "%#{term}%"])
    .order("view_count DESC")
  end

  # def self.created_after(time)
  #   where("created_at > ?", time)
  # end

  scope :created_after, lambda { |time| where("created_at > ?", time) }

  scope :recent, lambda { order("created_at DESC").limit(3)}

  def self.created_between(date1, date2)
    where("created_at > ? AND created_at < ?", date1, date2)
  end

  after_destroy do
    puts "The taste of death is sweet."
  end

  before_destroy :imma_method

  after_initialize :set_defaults

  def category_name
    category.name if category
  end

  # delegate :full_name, to: :user, prefix: true, allow_nil: true
  def user_full_name
    user.full_name if user
  end

  def like_for(user)
    likes.find_by_user_id user
  end

  def favourite_for(user)
    favourites.find_by_user_id user
  end

  # is this everything?
  def favourite_questions
    favourites
  end



  private

  def set_defaults
    self.view_count ||= 0
    # self.count_sale ||= view_count
  end

  def capitalize_title
    self.title.capitalize!
  end

  def no_monkey
    if title && title.downcase.include?("monkey")
      errors.add(:title, "No monkey!!")
    end
  end

  def imma_method
    puts "Don't destroy me."
  end


end
