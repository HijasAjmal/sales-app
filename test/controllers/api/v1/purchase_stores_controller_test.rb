require 'test_helper'

class Api::V1::PurchaseStoresControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_purchase_stores_index_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_purchase_stores_create_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_purchase_stores_update_url
    assert_response :success
  end

  test "should get delete" do
    get api_v1_purchase_stores_delete_url
    assert_response :success
  end

end
