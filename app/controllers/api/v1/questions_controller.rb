class Api::V1::QuestionsController < Api::BaseController
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

  def create
    question_params = params.require(:question).permit([:title, :body])
    question       = Question.new question_params
    question.user  = @user
    if question.save
      head :ok
    else
      render json: {errors: question.errors.full_messages}
    end
  end

end
