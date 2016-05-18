class QuestionsController < ApplicationController
  # this 'before_action' will call the 'find_quesiton' method before
  # executing any other action. We can specify :only or :except to be
  # more specific about the actions which before_action applies to
  # before_action :find_question, except: [:new, :create, :index]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, except: [:index, :show]

  before_action :authorize_user, only: [:edit, :destroy, :update]

  def new
    @question = Question.new
  end

  def create
    # params => {"question"=>{"title"=>"Title2", "body"=>"Body2"}}
    # question = Question.new
    # question.title = params[:question][:title]
    # question.body = params[:question][:body]
    # question.save

    # using params.require ensure that there is a key called 'question'
    # in my params. The 'permit' method will only allow params that
    # you explicitly list (title and body, in this case)
    @question = Question.new question_params
    @question.user = current_user
    if @question.save
      if @question.tweet_it
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = ENV["twitter_consumer_key"]
          config.consumer_secret     = ENV['twitter_consumer_secret']
          config.access_token        = current_user.twitter_token
          config.access_token_secret = current_user.twitter_secret
        end
        client.update("New Question: #{@question.title}")
      end
      #The below formats are possible ways to redirect in Rails:
      # redirect_to question_path({id: @question.id})
      # redirect_to question_path({id: @question})
      # redirect_to @question
      flash[:notice] = "Question Created Successfully!"
      redirect_to @question
      # redirect_to question_path(@question)
    else
      # This will render app/views/questions/new.html.erb template
      # We need to be explicit about rendering the new template
      # because the default behaviour is to render 'create.html.erb'
      # you can specify full path such as: render "question/new"
      flash[:alert] = "Question wasn't created. Check errors below"
      render :new
    end
  end

  # GET: /questions/13
  def show
    # @question = Question.find params[:id]
    @question.view_count += 1
    @question.save
    @answer = Answer.new
    respond_to do |format|
      format.html { render }
      format.json { render json: @question }
    end
  end

  def index
    @questions = Question.all
    respond_to do |format|
      format.html { render }
      format.json { render json: @questions.select(:id, :title, :view_count, :created_at) }
    end
  end

  def edit
    #we need to find the question that will be edited
    # @question = Question.find params[:id]
  end

  def update
    # we need to fetch the question first ot update it
    # @question = Question.find params[:id]

    # we must use strong params to only allow updating title & body
    # question_params = params.require(:question).permit(:title, :body)

    #update with sanitized params
    @question.update question_params
    #redirect to question show page
    redirect_to question_path(@question)
  end


  def destroy
    # @question = Question.find params[:id]
    @question.destroy
    redirect_to questions_path
  end

  private

  def question_params
    # using params. require ensures that there is a key called `question` in my
    # params. the `permit` method will only allow paramsters that you explicitly
    # list, in this case: title and body
    # this is called Strong Paramters
    params.require(:question).permit(:title, :body, :category_id, :tweet_it,
                                     { tag_ids: []} )
  end

  def find_question
    # @question = Question.find params[:id]
    @question = Question.includes(:answers =>
                :user).references(:answers).find(params[:id])
  end

  def authorize_user
    unless can? :manage, @question
      redirect_to root_path, alert: "access denied!"
    end
  end

end
