class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      #session["devise.facebook_data"] = request.env["omniauth.auth"]
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  
    alias_method :facebook, :all
    alias_method :twitter, :all
    alias_method :linkedin, :all
    alias_method :github, :all
    alias_method :passthru, :all
    alias_method :google_oauth2, :all

end