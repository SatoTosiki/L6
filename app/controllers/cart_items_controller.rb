class CartItemsController < ApplicationController
  def create
    product = Product.find(params.expect(cart_item: [ :product_id ])[:product_id])
    quantity = Integer(params.dig(:cart_item, :quantity) || 1, exception: false)
    quantity = 1 unless quantity&.positive?

    item = current_cart.cart_items.find_or_initialize_by(product: product)
    item.quantity = (item.quantity || 0) + quantity

    if item.save
      redirect_to cart_path(current_cart), notice: "商品をカートに追加しました。"
    else
      redirect_to products_path, alert: "数量を確認してください。"
    end
  end

  def destroy
    current_cart.cart_items.find(params.expect(:id)).destroy!
    redirect_to cart_path(current_cart), notice: "商品をカートから削除しました。", status: :see_other
  end
end
