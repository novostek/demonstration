require "application_system_test_case"

class DocumentFilesTest < ApplicationSystemTestCase
  setup do
    @document_file = document_files(:one)
  end

  test "visiting the index" do
    visit document_files_url
    assert_selector "h1", text: "Document Files"
  end

  test "creating a Document file" do
    visit document_files_url
    click_on "New Document File"

    check "Esign" if @document_file.esign
    fill_in "Esign data", with: @document_file.esign_data
    fill_in "File", with: @document_file.file
    fill_in "Origin", with: @document_file.origin
    fill_in "Origin", with: @document_file.origin_id
    fill_in "Photo", with: @document_file.photo
    fill_in "Photo date", with: @document_file.photo_date
    fill_in "Photo description", with: @document_file.photo_description
    fill_in "Title", with: @document_file.title
    click_on "Create Document file"

    assert_text "Document file was successfully created"
    click_on "Back"
  end

  test "updating a Document file" do
    visit document_files_url
    click_on "Edit", match: :first

    check "Esign" if @document_file.esign
    fill_in "Esign data", with: @document_file.esign_data
    fill_in "File", with: @document_file.file
    fill_in "Origin", with: @document_file.origin
    fill_in "Origin", with: @document_file.origin_id
    fill_in "Photo", with: @document_file.photo
    fill_in "Photo date", with: @document_file.photo_date
    fill_in "Photo description", with: @document_file.photo_description
    fill_in "Title", with: @document_file.title
    click_on "Update Document file"

    assert_text "Document file was successfully updated"
    click_on "Back"
  end

  test "destroying a Document file" do
    visit document_files_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Document file was successfully destroyed"
  end
end
