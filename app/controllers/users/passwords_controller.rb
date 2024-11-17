# app/controllers/users/passwords_controller.rb
class Users::PasswordsController < Devise::PasswordsController
  def create
    Rails.logger.debug "Parameters received: #{params.inspect}"

    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      reset_token = resource.reset_password_token
      Rails.logger.debug "Reset password token sent: #{reset_token}"
      redirect_to edit_user_password_url(reset_password_token: reset_token)
    else
      flash[:alert] = resource.errors.full_messages.join(", ")
      respond_with(resource)
    end
  end


  def update
    Rails.logger.debug "Parameters received for update: #{params.inspect}"
    Rails.logger.debug "Permitted parameters for update: #{resource_params.inspect}"

    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      flash[:notice] = "Your password has been successfully updated. Please log in."
      redirect_to new_user_session_path
    else
      Rails.logger.debug "Validation errors: #{resource.errors.full_messages.join(", ")}"
      flash[:alert] = resource.errors.full_messages.join(", ")
      respond_with(resource)
    end
  end


  def edit
    @token = params[:reset_password_token]
    super
  end



  private


  #def resource_params
    #if action_name == 'create'
      # Permit only the email for the `create` action
      #params.require(:user).permit(:email)
    #else
      # Permit password reset parameters for the `update` action
      #params.require(:user).permit(:password, :password_confirmation, :reset_password_token)
    #end
  #end

  def resource_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end

end
