class Api::V1::QuestionsController < ApplicationController
#JBuilder or ActivModel Serializer to customize json
#jbuilder gem comes with rails
  def index
    @questions = Question.order("created_at DESC").limit(10)
    render json: @questions
  end

  def show
    @question = Question.find_by_id params[:id]
    # send JSON that has :all attributes of the question, list of answers,
    # list of answers (JSON array), list of tags (JSON array)
    render json: @question

  end

end
