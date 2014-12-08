class PaymentsController < ApplicationController
  authorize_actions_for Payment
  before_filter :authenticate
  # GET /payments
  # GET /payments.json
  def index
    @payments = Payment.all

    error = @payments.select{|p| p.payment_date.blank?}.map(&:id).join(", ")
    if error.present?
      error = "Payments missing payment_date: " + error
    end


    respond_to do |format|
      flash.alert = error if error.present?
      format.html # index.html.erb
      format.csv { render csv: @payments }
      format.json { render json: @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
    @payment = Payment.new
    @payment.invoice = params[:id].blank? ? Invoice.new : Invoice.find(params[:id])
    (@payment.account = @payment.invoice.account) unless @payment.invoice.blank?
    @payment.account = Account.find(params[:account_id]) unless params[:account_id].blank?
    @payment.amount = @payment.invoice.balance_due unless @payment.invoice.blank?


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(params[:payment])

    respond_to do |format|
      if @payment.save
        format.html { redirect_to invoices_url, notice: 'Payment was successfully created.' }
        format.json { render json: @payment, status: :created, location: @payment }
        InvoiceMailer.new_payment_email(@payment,current_user).deliver
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to payments_url, notice: 'Payment was successfully updated.' }
        format.json { head :no_content }
        InvoiceMailer.payment_edited_email(@payment,current_user).deliver
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    errors = Payment.import(params[:file])
    message =  (errors.length > 0) ? errors.join(", ") : "Payments successfully imported."
    redirect_to payments_url, notice: message
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url }
      format.json { head :no_content }
    end
  end
end
