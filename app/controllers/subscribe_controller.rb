class SubscribeController < ApplicationController
  def index
    # this renders the app/views/welcome/about.hrml.erb template
    # with no layout
    # render "/welcome/about", layout: false
  end

  # def show
  #   @subscription = Subscription.find(params[:id])
  # end

  def create
    # @subscription = Subscription.new(name: params[:name], email: params[:email])
    # Subscription.new(name: "kelsey", email: "lol@fake.com")
    # if @subscription.save
    #   redirect_to subscribe_show(@subscription)
    #   redirect_to "/subscribe/?id=3"
    # else
    #   render text: "error"
    # end

  end

end
