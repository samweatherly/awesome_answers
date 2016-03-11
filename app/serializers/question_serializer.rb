class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :created_at

  has_many :answers

  def title
    object.title.titleize
  end

  def creation_date
    object.created_at.strftime("%Y-%b-%d")
  end
end
