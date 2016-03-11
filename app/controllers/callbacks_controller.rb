class CallbacksController < ApplicationController
  def twitter
    # search for the user with their uid/provider, if we find the user then
    # we log the user in, otherwise, we create a new user account.
    omniauth_data = request.env['omniauth.auth']
    user = User.find_twitter_user(omniauth_data)
    # Create the user account if it doesn't exist
    user ||= User.create_from_twitter(omniauth_data)
    # byebug
    sign_in(user)
    redirect_to root_path, notice: "Signed In!"
  end
end
