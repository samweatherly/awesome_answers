class Favourite < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :user_id, :question_id, presence: true
  validates :user_id, uniqueness: { scope: :question_id }
end
