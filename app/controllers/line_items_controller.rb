class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_line_item, only: %i[show edit update destroy]
  before_action :set_cart, only: %i[create decrease increase]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show; end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit; end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_index_url }
        format.js { @current_item = @line_item }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def decrease
    # @cart = current_cart
    @line_item = @cart.decrease(params[:id])

    respond_to do |format|
      if @line_item.save
        format.html do
          redirect_to store_path, notice: 'Line item was successfully
          updated.'
        end
        format.js   { @current_item = @line_item }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def increase
    # @cart = current_cart
    @line_item = @cart.increase(params[:id])

    respond_to do |format|
      if @line_item.save
        format.html do
          redirect_to store_path, notice: 'Line item was successfully
            updated.'
        end
        format.js   { @current_item = @line_item }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html do
        redirect_to line_items_url, notice: 'Line item was successfully
        destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def line_item_params
    params.require(:line_item).permit(:product_id)
  end
end