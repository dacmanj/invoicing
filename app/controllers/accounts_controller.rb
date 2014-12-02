class AccountsController < ApplicationController
  before_filter :authenticate
  # GET /account
  # GET /account.json
  def index
    name = params[:name]

    @accounts = Account.where("name ILIKE ?", "%#{name}%").order(:name) unless name.blank?
    @accounts = @accounts || Account.order(:name)

    if params[:outstanding_balance]
      @accounts = @accounts.select{|a| a.balance_due > 0 }
      @accounts = @accounts.sort_by{ |e| e["name"]}
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accounts }
    end
  end

  # GET /account/1
  # GET /account/1.json
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account }
    end
  end


  def new_modal
    @account = Account.new
    @account.default_account_ar_account = '1110'
    contact = @account.contacts.build
    contact.active = true
    contact.address = Address.new
    respond_to do |format|
      format.html { render 'new', :layout => 'embed' }
      format.json { render json: @hash }
    end   
  end

  # GET /account/new
  # GET /account/new.json
  def new
    @account = Account.new
    @account.default_account_ar_account = '1110'
    contact = @account.contacts.build
    contact.active = true
    contact.address = Address.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account }
    end
  end

  # GET /account/1/edit
  def edit
    @account = Account.find(params[:id])
    @contacts = @account.contacts
    @invoices = @account.invoices
    @payments = @account.payments
    @email_records = @account.email_records
  end

  # POST /account
  # POST /account.json
  def create
    @account = Account.new(params[:account])

    respond_to do |format|
      if @account.save
        format.html { redirect_to accounts_url, notice: 'Account was successfully created.' }
        format.json { render json: @account, status: :created, location: @account }
      else
        format.html { render action: "new" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /account/1
  # PUT /account/1.json
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to accounts_url, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/1
  # DELETE /account/1.json
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end

  def import
    errors = Account.import(params[:file],params[:override])
    message =  (errors.length > 0) ? errors.join(", ") : "Items successfully imported."
    redirect_to accounts_url, notice: message
  end
end
