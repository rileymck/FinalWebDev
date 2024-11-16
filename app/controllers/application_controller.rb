class ApplicationController < ActionController::Base
    before_action :authenticate_user!

    def after_sign_out_path_for(resource_or_scope)
        new_user_session_path # Redirect to the sign-in page
      end
end


#class ApplicationController < ActionController::Base
    #before_action :authenticate_user!  # Ensures authentication is required for actions
  
    # Ensure Devise mappings and parameters are loaded in each controller
    #before_action :configure_permitted_parameters, if: :devise_controller?
  
    #protected
  
    #def configure_permitted_parameters
      #devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
      #devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :current_password])
    #end
  #end
  