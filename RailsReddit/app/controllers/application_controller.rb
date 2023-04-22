class ApplicationController < ActionController::Base

    # CHR(R)LLL

    helper_method

    def current_user

    end

    def require_logged_in
        if !logged_in?
            redirect_to new_session_url
        end
    end

    def login!(user)

    end

    def logout!

    end

    def logged_in?

    end

end
