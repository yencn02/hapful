require 'test_helper'

class Admin::ShippingOptionsControllerTest < ActionController::TestCase
  setup do
    @admin_shipping_option = admin_shipping_options(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_shipping_options)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_shipping_option" do
    assert_difference('Admin::ShippingOption.count') do
      post :create, :admin_shipping_option => @admin_shipping_option.attributes
    end

    assert_redirected_to admin_shipping_option_path(assigns(:admin_shipping_option))
  end

  test "should show admin_shipping_option" do
    get :show, :id => @admin_shipping_option.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @admin_shipping_option.to_param
    assert_response :success
  end

  test "should update admin_shipping_option" do
    put :update, :id => @admin_shipping_option.to_param, :admin_shipping_option => @admin_shipping_option.attributes
    assert_redirected_to admin_shipping_option_path(assigns(:admin_shipping_option))
  end

  test "should destroy admin_shipping_option" do
    assert_difference('Admin::ShippingOption.count', -1) do
      delete :destroy, :id => @admin_shipping_option.to_param
    end

    assert_redirected_to admin_shipping_options_path
  end
end
