require 'test_helper'

class DealsControllerTest < ActionController::TestCase
  setup do
    @deal = deals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:deals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create deal" do
    assert_difference('Deal.count') do
      post :create, deal: { bargain_id: @deal.bargain_id, bid_id: @deal.bid_id, dealer_id: @deal.dealer_id, final_price: @deal.final_price, postscript: @deal.postscript, tender_id: @deal.tender_id, user_id: @deal.user_id }
    end

    assert_redirected_to deal_path(assigns(:deal))
  end

  test "should show deal" do
    get :show, id: @deal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @deal
    assert_response :success
  end

  test "should update deal" do
    patch :update, id: @deal, deal: { bargain_id: @deal.bargain_id, bid_id: @deal.bid_id, dealer_id: @deal.dealer_id, final_price: @deal.final_price, postscript: @deal.postscript, tender_id: @deal.tender_id, user_id: @deal.user_id }
    assert_redirected_to deal_path(assigns(:deal))
  end

  test "should destroy deal" do
    assert_difference('Deal.count', -1) do
      delete :destroy, id: @deal
    end

    assert_redirected_to deals_path
  end
end
