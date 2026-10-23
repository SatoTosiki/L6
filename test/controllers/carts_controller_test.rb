require "test_helper"

class CartsControllerTest < ActionDispatch::IntegrationTest
  test "shows the cart associated with the browser session" do
    get products_url
    cart = Cart.order(:id).last
    product = products(:one)
    cart.cart_items.create!(product: product, quantity: 2)

    get cart_url(carts(:two))

    assert_response :success
    assert_select "td", product.name
    assert_select "td", "2"
    assert_select "td", "¥#{product.price * 2}"
  end
end
