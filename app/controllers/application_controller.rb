class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  include AbstractController::Translation

  before_action :authenticate_user_from_token!

  respond_to :json

  ##
  # User Authentication
  # Authenticates the user with OAuth2 Resource Owner Password Credentials Grant
  def authenticate_user_from_token!
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token auth_token
    else
      authentication_error
    end
  end

  private

  def authenticate_with_auth_token auth_token
    authentication_error unless auth_token.include?(':')

    user_id = auth_token.split(':').first
    user = User.where(id: user_id).first

    if user && Devise.secure_compare(user.access_token, auth_token)
      sign_in user, store: false
    else
      authentication_error
    end
  end

  ##
  # Authentication Failure
  # Renders a 401 error
  def authentication_error
    # User's token is either invalid or not in the right format
    render json: {error: t('unauthorized')}, status: 401  and return # Authentication timeout
  end
end
