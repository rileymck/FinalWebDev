class ThemeController < ApplicationController
    skip_before_action :authenticate_user!, raise: false
    skip_before_action :require_no_authentication, raise: false

    def update
        cookies[:theme] = params[:theme]
        redirect_to(request.referrer || root_path) 
    end
end