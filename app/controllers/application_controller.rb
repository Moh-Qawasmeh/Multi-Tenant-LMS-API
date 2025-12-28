class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def authenticate_user!
    user = warden.authenticate(scope: :user)
    Current.user = user if user
  end
end
