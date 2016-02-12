class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :comments, dependent: :destroy

  # Adding uniquness: {scope: :question_id} will mae sure that an answer's
  # body is unique for a given question. This means you can't submit the
  # same answer body twice for a given question. BUT you can submit the
  # same answer body for two different questions.
  validates :body, presence: true, uniqueness: {scope: :question_id}

  def user_full_name
    user.full_name if user
  end

end
