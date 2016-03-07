class VotesController < ApplicationController

  def create
    question          = Question.find params[:question_id]
    vote              = Vote.new vote_params
    vote.user         = current_user
    vote.question     = question
    flash = (vote.save) ? {notice: "Voted!"} : {alert: "Try again"}
    redirect_to question_path(question), flash
    # if vote.save
    #   redirect_to question_path(question), notice: "Voted!"
    # else
    #   redirect_to question_path(question), alert: "Try again!"
    # end
  end

  def update
    question = Question.find params[:question_id]
    vote = current_user.votes.find params[:id]
    if vote.update vote_params
      redirect_to question_path(question), notice: "Vote updated"
    else
      redirect_to question_path(question), alert: "Try again"
    end
  end

  def destroy
    question = Question.find params[:question_id]
    vote = current_user.votes.find params[:id]
    vote.destroy
    redirect_to question_path(question), notice: "Vote removed"
  end

  private

  def vote_params
    params.require(:vote).permit(:is_up)
  end
end
