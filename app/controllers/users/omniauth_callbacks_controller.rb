class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def omniauth_callback
    super
  end

  def github
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    Rails.logger.ap request.env["omniauth.auth"]
    user = User.from_omniauth(request.env["omniauth.auth"])

    if user.persisted?
      # this will throw if user is not activated
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      session["devise.github_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end
end
