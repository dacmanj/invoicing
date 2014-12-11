class UsersController < ApplicationController
  before_filter :authenticate
  authorize_actions_for User, :except => [:show, :edit, :update]

  def index
    @users = User.all
  end

  def new
    @user = User.new    
  end

  def edit
    @user = User.find(params[:id])
    authorize_action_for(@user)
  end
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @user = User.find(params[:id])
    authorize_action_for(@user)
    [:role_ids,:provider,:uid].each { |h| params[:user].delete(h) } unless current_user.has_role? :admin
    params[:user].delete(:notify_on_all_actions) unless (current_user.has_role? :staff or current_user.has_role? :admin)
    
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path @user
    else
      render :edit
    end
  end


def show
    @user = User.find(params[:id])
    authorize_action_for(@user)
  end

end
