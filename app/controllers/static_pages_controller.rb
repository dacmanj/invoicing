class StaticPagesController < ApplicationController
  def home
  	redirect_to invoices_url if !current_user.blank?
  end

  def import
  end

  def help
  end
end
