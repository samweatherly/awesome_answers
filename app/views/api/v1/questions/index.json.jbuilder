json.array! @questions do |question|
  json.id question.id
  json.title question.title.titleize
  json.body question.body
  json.creation_date question.created_at.strftime("%Y-%b-%d")
  json.answer_count question.answers.count
  json.category question.category_name
  json.creator question.user_full_name
end
