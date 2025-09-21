class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Authentication

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: "forbidden" }, status: :forbidden
  end
end
