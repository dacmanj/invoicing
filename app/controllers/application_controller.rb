class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  after_filter :flash_to_headers

    # Send 'em back where they came from with a slap on the wrist
    def authority_forbidden(error)
      Authority.logger.warn(error.message)
      Authority.logger.warn(error.resource)
      Authority.logger.warn(error.user)
      redirect_to request.referrer.presence || root_path, :alert => "You are not authorized to complete that action."
    end

  private
    def current_user
      begin
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      rescue Exception => e
        nil
      end
    end

    def user_signed_in?
      return true if current_user
    end

    def correct_user?
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, :alert => "Access denied."
      end
    end

    def authenticate_user!
      if !current_user
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
    end


    def flash_to_headers
    # if AJAX request add messages to heaader
      return unless request.xhr?

      message = ''
      message_type = :error

      [:error, :warning, :notice, :success].each do |type|
        unless flash[type].blank?
          message = flash[type]
          message_type = type.to_s

        end
      end

      unless message.blank?
      # We need encode our message, because we can't use      
      # unicode symbols in headers
        response.headers['X-Message'] = URI::encode message
        response.headers['X-Message-Type'] = message_type
        # Clear messages
        flash.discard
      end
    end


end
