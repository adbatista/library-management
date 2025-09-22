class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]

  def create
    user = User.new(params.expect(user: [ :name, :email_address, :password, :password_confirmation, :user_type ]))

    if user.save
      render json: user.as_json(except: :password_digest), status: :created
    else
      render json: user.errors, status: :unprocessable_content
    end
  end
end
