class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    include Pundit
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    
    rescue_from ActiveRecord::RecordNotFound do
        render :file => "/public/404.html", :status => :not_found
    end
    
    protected
        def configure_permitted_parameters
            devise_parameter_sanitizer.for(:sign_up) << :name
            devise_parameter_sanitizer.for(:sign_up) << :birth_date
            devise_parameter_sanitizer.for(:account_update) << :name
            devise_parameter_sanitizer.for(:account_update) << :birth_date
            devise_parameter_sanitizer.for(:account_update) << :about_me
            devise_parameter_sanitizer.for(:account_update) << :address
            devise_parameter_sanitizer.for(:account_update) << :image
        end
end
