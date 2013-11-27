class UsersController < ApplicationController
  before_filter :authenticate

  def index
    @users = User.all
  end

  def new
    @user = User.new    
  end

  def edit
    @user = User.find(params[:id])
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
    if @user.update_attributes(params[:user])
      redirect_to users_path
    else
      render :edit
    end
  end


def show
    @user = User.find(params[:id])
  end

end
