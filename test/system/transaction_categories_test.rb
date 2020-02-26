require "application_system_test_case"

class TransactionCategoriesTest < ApplicationSystemTestCase
  setup do
    @transaction_category = transaction_categories(:one)
  end

  test "visiting the index" do
    visit transaction_categories_url
    assert_selector "h1", text: "Transaction Categories"
  end

  test "creating a Transaction category" do
    visit transaction_categories_url
    click_on "New Transaction Category"

    fill_in "Color", with: @transaction_category.color
    fill_in "Description", with: @transaction_category.description
    fill_in "Name", with: @transaction_category.name
    fill_in "Namespace", with: @transaction_category.namespace
    click_on "Create Transaction category"

    assert_text "Transaction category was successfully created"
    click_on "Back"
  end

  test "updating a Transaction category" do
    visit transaction_categories_url
    click_on "Edit", match: :first

    fill_in "Color", with: @transaction_category.color
    fill_in "Description", with: @transaction_category.description
    fill_in "Name", with: @transaction_category.name
    fill_in "Namespace", with: @transaction_category.namespace
    click_on "Update Transaction category"

    assert_text "Transaction category was successfully updated"
    click_on "Back"
  end

  test "destroying a Transaction category" do
    visit transaction_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Transaction category was successfully destroyed"
  end
end
