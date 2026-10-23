require "test_helper"

class CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "adds product to session cart and aggregates quantity" do
    product = products(:one)

    assert_difference("CartItem.count", 1) do
      post cart_items_url, params: { cart_item: { product_id: product.id, quantity: 2, cart_id: carts(:two).id } }
    end
    post cart_items_url, params: { cart_item: { product_id: product.id, quantity: 3 } }

    item = CartItem.order(:id).last
    assert_equal 5, item.quantity
    assert_equal Cart.last.id, item.cart_id
    assert_redirected_to cart_url(Cart.last)
  end

  test "removes only items from the session cart" do
    get products_url
    cart = Cart.order(:id).last
    item = cart.cart_items.create!(product: products(:one), quantity: 1)

    assert_difference("CartItem.count", -1) do
      delete cart_item_url(item)
    end
    assert_redirected_to cart_url(item.cart)
  end
end
