module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || render(json: { message: "unauthorized" }, status: :unauthorized)
    end

    def resume_session
      Current.session ||= find_session_by_token
    end

    def current_user
      Current.session&.user
    end

    def find_session_by_token
      authenticate_with_http_token do |token, options|
        Session.find_by(token: token)
      end
    end


    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
      end
    end

    def terminate_session
      Current.session.destroy
    end
end
