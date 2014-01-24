class EmailRecordsController < ApplicationController
  before_filter :authenticate
  # GET /email_records
  # GET /email_records.json
  def index
    @email_records = EmailRecord.order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @email_records }
    end
  end

  # GET /email_records/1
  # GET /email_records/1.json
  def show
    @email_record = EmailRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @email_record }
    end
  end

  # GET /email_records/new
  # GET /email_records/new.json
  def new
    @email_record = EmailRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @email_record }
    end
  end

  # GET /email_records/1/edit
  def edit
    @email_record = EmailRecord.find(params[:id])
  end

  # POST /email_records
  # POST /email_records.json
  def create
    @email_record = EmailRecord.new(params[:email_record])

    respond_to do |format|
      if @email_record.save
        format.html { redirect_to @email_record, notice: 'Email record was successfully created.' }
        format.json { render json: @email_record, status: :created, location: @email_record }
      else
        format.html { render action: "new" }
        format.json { render json: @email_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /email_records/1
  # PUT /email_records/1.json
  def update
    @email_record = EmailRecord.find(params[:id])

    respond_to do |format|
      if @email_record.update_attributes(params[:email_record])
        format.html { redirect_to @email_record, notice: 'Email record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @email_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_records/1
  # DELETE /email_records/1.json
  def destroy
    @email_record = EmailRecord.find(params[:id])
    @email_record.destroy

    respond_to do |format|
      format.html { redirect_to email_records_url }
      format.json { head :no_content }
    end
  end
end
