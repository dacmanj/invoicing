class EmailTemplatesController < ApplicationController
  before_filter :authenticate
  # GET /templates
  # GET /templates.json
  def index
    @templates = EmailTemplate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @templates }
    end
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
    @template = EmailTemplate.find(params[:id])

    respond_to do |format|
      format.html { render action: "edit" }
      format.json { render json: @template }
    end
  end

  # GET /email_templates/new
  # GET /email_templates/new.json
  def new
    @template = EmailTemplate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @template }
    end
  end

  # GET /email_templates/1/edit
  def edit
    @template = EmailTemplate.find(params[:id])
  end

  # POST /email_templates
  # POST /email_templates.json
  def create
    @template = EmailTemplate.new(params[:email_template])

    respond_to do |format|
      if @template.save
        format.html { redirect_to email_templates_url, notice: 'Email Template was successfully created.' }
        format.json { render json: @template, status: :created, location: @template }
      else
        format.html { render action: "new" }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /email_templates/1
  # PUT /email_templates/1.json
  def update
    @template = EmailTemplate.find(params[:id])

    respond_to do |format|
      if @template.update_attributes(params[:email_template])
        format.html { redirect_to @template, notice: 'Email Template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_templates/1
  # DELETE /email_templates/1.json
  def destroy
    @template = EmailTemplate.find(params[:id])
    @template.destroy

    respond_to do |format|
      format.html { redirect_to email_templates_url }
      format.json { head :no_content }
    end
  end
end
