require 'test_helper'

class TransactionAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transaction_account = transaction_accounts(:one)
  end

  test "should get index" do
    get transaction_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_transaction_account_url
    assert_response :success
  end

  test "should create transaction_account" do
    assert_difference('TransactionAccount.count') do
      post transaction_accounts_url, params: { transaction_account: { color: @transaction_account.color, description: @transaction_account.description, name: @transaction_account.name, namespace: @transaction_account.namespace } }
    end

    assert_redirected_to transaction_account_url(TransactionAccount.last)
  end

  test "should show transaction_account" do
    get transaction_account_url(@transaction_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_transaction_account_url(@transaction_account)
    assert_response :success
  end

  test "should update transaction_account" do
    patch transaction_account_url(@transaction_account), params: { transaction_account: { color: @transaction_account.color, description: @transaction_account.description, name: @transaction_account.name, namespace: @transaction_account.namespace } }
    assert_redirected_to transaction_account_url(@transaction_account)
  end

  test "should destroy transaction_account" do
    assert_difference('TransactionAccount.count', -1) do
      delete transaction_account_url(@transaction_account)
    end

    assert_redirected_to transaction_accounts_url
  end
end
