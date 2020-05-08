require "application_system_test_case"

class TransactionAccountsTest < ApplicationSystemTestCase
  setup do
    @transaction_account = transaction_accounts(:one)
  end

  test "visiting the index" do
    visit transaction_accounts_url
    assert_selector "h1", text: "Transaction Accounts"
  end

  test "creating a Transaction account" do
    visit transaction_accounts_url
    click_on "New Transaction Account"

    fill_in "Color", with: @transaction_account.color
    fill_in "Description", with: @transaction_account.description
    fill_in "Name", with: @transaction_account.name
    fill_in "Namespace", with: @transaction_account.namespace
    click_on "Create Transaction account"

    assert_text "Transaction account was successfully created"
    click_on "Back"
  end

  test "updating a Transaction account" do
    visit transaction_accounts_url
    click_on "Edit", match: :first

    fill_in "Color", with: @transaction_account.color
    fill_in "Description", with: @transaction_account.description
    fill_in "Name", with: @transaction_account.name
    fill_in "Namespace", with: @transaction_account.namespace
    click_on "Update Transaction account"

    assert_text "Transaction account was successfully updated"
    click_on "Back"
  end

  test "destroying a Transaction account" do
    visit transaction_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Transaction account was successfully destroyed"
  end
end
