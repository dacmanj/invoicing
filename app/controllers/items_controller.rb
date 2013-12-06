class ItemsController < ApplicationController
  before_filter :authenticate
  # GET /items
  # GET /items.json
  def index
    @items = Item.includes(:lines).order("items.recurring DESC, items.account_id, items.invoice_id")

    item_id = params[:item_id]
    invoice_id = params[:invoice_id]
    account_id = params[:account_id]
    assigned = params[:assigned]
    recurring = params[:recurring]
    notes = params[:notes]
    description = params[:description]

    if (item_id.present?)
      @items = Item.where("id = ?",item_id)     
    else
  #    @items = @items.where("account_id = ? OR recurring IS true",account_id) unless account_id.blank?
      #Item.where("recurring IS true").each{|i| @items.push(i)} unless recurring = "no"

      if (assigned != "yes")
        @items = @items.where("lines.id IS NULL")
      end

      Item.where("account_id = ?",invoice_id).each{|i| @items.push(i)} unless account_id.blank?
      Item.includes(:lines).where("lines.invoice_id = ?",invoice_id).each{|i| @items.push(i)} unless invoice_id.blank?

      if (recurring == "yes")
        @items = @items.where("recurring IS true")
      end

      if (recurring == "no")
        @items = @items.where("recurring IS false")
      end


      @items = @items.where("items.notes ILIKE ?", "%#{notes}%") unless notes.blank?
      @items = @items.where("items.description ILIKE ?", "%#{description}%") unless description.blank?
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items.to_json(:methods => [:name]) }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def import
    message = Item.import(params[:file],params[:override])
    redirect_to items_url, notice: message.join("<br>")
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to items_url, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_multiple


    if (params[:new_invoice] == "1")
      if !params[:account_id].blank?
        redirect_to :controller => 'invoices', :action => 'new', :item_id => params[:item_id], :account_id => params[:account_id]
      else
        redirect_to :controller => 'invoices', :action => 'new', :item_id => params[:item_id]
      end
      return
    end

    @items = Item.find_all_by_id(params[:item_id])

    errors = Array.new
    @items.each do |i| 
      if params[:delete] == "1"
        i.destroy
        next
      end
    i.account_id = (params[:account_id] unless params[:account_id].blank?) || i.account_id
    i.assign_to_invoice(params[:invoice_id]) unless params[:delete] or params[:invoice_id].blank?
    i.save!

    end

    message =  (errors.length > 0) ? errors.join(", ") : "Items successfully updated."
    redirect_to items_url, notice: message

  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
end
