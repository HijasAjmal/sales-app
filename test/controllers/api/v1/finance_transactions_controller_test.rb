require 'test_helper'

class Api::V1::FinanceTransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_finance_transactions_index_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_finance_transactions_create_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_finance_transactions_show_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_finance_transactions_destroy_url
    assert_response :success
  end

end
