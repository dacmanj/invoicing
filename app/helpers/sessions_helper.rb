module SessionsHelper

  def sign_in(user)
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def authenticate
    deny_access unless signed_in?
  end

  def require_admin
    deny_access unless signed_in? && administrator?
  end

  def require_admin_except_json
    unless signed_in? && request.format.js?
      deny_access unless signed_in? && administrator?
    end
  end

  def require_admin_except_key(params)
    deny_access unless signed_in? && administrator? || params[:key] == '123'
  end

  def administrator?
    signed_in? && current_user.administrator?
  end

  def supervisor?
    signed_in? && current_user.administrator?
  end

  def deny_access
    store_location
    if signed_in?
      redirect_to work_logs_path, :notice => "Insufficient privileges to access that feature."
    else
      redirect_to signin_path
    end
  end

  def redirect_back_or(default, notice)
    redirect_to(session[:return_to] || default, notice)
    session.delete(:return_to)
  end

  private

    def store_location

      session[:return_to] = request.fullpath unless
        request.fullpath.match("/signin") || !session[:return_to].blank?
    end

    def clear_return_to
      session.delete(:return_to)
    end

end