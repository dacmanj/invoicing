class StaticPagesController < ApplicationController
  before_filter :authenticate
  skip_before_filter :authenticate, :only => [:home]
  def home
 # 	redirect_to invoices_url if !current_user.blank?
  end

  def import
  end

  def help
  end
end
