require 'test_helper'

class TendersControllerTest < ActionController::TestCase
  setup do
    @tender = tenders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tenders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tender" do
    assert_difference('Tender.count') do
      post :create, tender: { description: @tender.description, model: @tender.model, price: @tender.price }
    end

    assert_redirected_to tender_path(assigns(:tender))
  end

  test "should show tender" do
    get :show, id: @tender
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tender
    assert_response :success
  end

  test "should update tender" do
    patch :update, id: @tender, tender: { description: @tender.description, model: @tender.model, price: @tender.price }
    assert_redirected_to tender_path(assigns(:tender))
  end

  test "should destroy tender" do
    assert_difference('Tender.count', -1) do
      delete :destroy, id: @tender
    end

    assert_redirected_to tenders_path
  end
end
