require 'test_helper'

class BidsControllerTest < ActionController::TestCase
  setup do
    @bid = bids(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bid" do
    assert_difference('Bid.count') do
      post :create, bid: { dealer_id: @bid.dealer_id, description: @bid.description, price: @bid.price, tender_id: @bid.tender_id }
    end

    assert_redirected_to bid_path(assigns(:bid))
  end

  test "should show bid" do
    get :show, id: @bid
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bid
    assert_response :success
  end

  test "should update bid" do
    patch :update, id: @bid, bid: { dealer_id: @bid.dealer_id, description: @bid.description, price: @bid.price, tender_id: @bid.tender_id }
    assert_redirected_to bid_path(assigns(:bid))
  end

  test "should destroy bid" do
    assert_difference('Bid.count', -1) do
      delete :destroy, id: @bid
    end

    assert_redirected_to bids_path
  end
end
