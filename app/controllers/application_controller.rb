class ApplicationController < ActionController::Base
  helper_method :current_cart
  before_action :current_cart

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def current_cart
    @current_cart ||= begin
      Cart.find_by(id: session[:cart_id]) || Cart.create!.tap do |cart|
        session[:cart_id] = cart.id
      end
    end
  end
end
