class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]
  before_action :get_categories, only: [:index, :show]

  def index
    @ladies = Item.ransack(by_category_id: 1.0).result.limit(4)
    @mens = Item.ransack(by_category_id: 2).result.limit(4)
    @kids = Item.ransack(by_category_id: 3).result.limit(4)
    @janel = Item.ransack(brand_id_eq: 1).result.limit(4)
    @biton = Item.ransack(brand_id_eq: 3).result.limit(4)
    @shrimp = Item.ransack(brand_id_eq: 4).result.limit(4)
    @mike = Item.ransack(brand_id_eq: 2).result.limit(4)
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
    @item.item_images.build
    @categories = Category.ransack(parent_id_null: true).result
    @brands = Brand.all
    @regions = Region.all
    @itemimage = ItemImage.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save

    else

    end
  end

  def edit
    @item = Item.find(params[:id])
    # @item_images = @item.item_images
    # @item.item_images.build
    @categories = Category.ransack(parent_id_null: true).result

  end
  def pay
    # @item = Item.find(params[:id])
    if
      Payjp.api_key = 'sk_test_c28ae49cafa2c8609f211aea'
      charge = Payjp::Charge.create(
      :amount => 1000,
      :card => params['payjp-token'],
      :currency => 'jpy',)
      redirect_to root_path,
    else
      redirect_to root_path,
    end
  end

      respond_to do |format|
        format.html
        format.json
      end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
  end

  private

  def item_params
    params.require(:item).permit(:name, :comment, :category_id, :brand_id, :shipping_fee, :prefecture_id, :days_to_ship, :price, :condition, item_images_attributes: [:image]).merge(user_id: current_user.id)
  end

  def get_categories
    @all_categories = Category.all
  end

  def buy
  end
end
