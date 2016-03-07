class FavouritesController < ApplicationController
  before_action :authenticate_user


  def index
    # @favourites = current_user.favourites
    @questions = current_user.favourite_questions
    # @questions = current_user.favourites.map do { |x| Question.find(x) }
    # Question.find(fav.question_id).title, question_path(fav.question_id)
  end

  def create
    @question = Question.find params[:question_id]
    favourite = Favourite.new(question: @question, user: current_user)
    respond_to do |format|
      if favourite.save
        format.html { redirect_to @question, notice: "Favourited!" }
        format.js { render :successfully_favourited }
      else
        format.html { redirect_to @question, alert: "Not Favourited!" }
        format.js { render :unsuccessfully_favourited }
      end
    end
  end

  def destroy
    favourite = current_user.favourites.find params[:id]
    @question = Question.find params[:question_id]
    favourite.destroy
    respond_to do |format|
      format.html { redirect_to @question, notice: "Un-favourited!" }
      format.js   { render }
    end
  end

end
