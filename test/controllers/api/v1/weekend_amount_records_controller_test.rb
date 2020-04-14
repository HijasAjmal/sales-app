require 'test_helper'

class Api::V1::WeekendAmountRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_weekend_amount_records_index_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_weekend_amount_records_create_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_weekend_amount_records_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_weekend_amount_records_destroy_url
    assert_response :success
  end

  test "should get list_records" do
    get api_v1_weekend_amount_records_list_records_url
    assert_response :success
  end

end
