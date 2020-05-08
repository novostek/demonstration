require 'test_helper'

class DocumentFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @document_file = document_files(:one)
  end

  test "should get index" do
    get document_files_url
    assert_response :success
  end

  test "should get new" do
    get new_document_file_url
    assert_response :success
  end

  test "should create document_file" do
    assert_difference('DocumentFile.count') do
      post document_files_url, params: { document_file: { esign: @document_file.esign, esign_data: @document_file.esign_data, file: @document_file.file, origin: @document_file.origin, origin_id: @document_file.origin_id, photo: @document_file.photo, photo_date: @document_file.photo_date, photo_description: @document_file.photo_description, title: @document_file.title } }
    end

    assert_redirected_to document_file_url(DocumentFile.last)
  end

  test "should show document_file" do
    get document_file_url(@document_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_document_file_url(@document_file)
    assert_response :success
  end

  test "should update document_file" do
    patch document_file_url(@document_file), params: { document_file: { esign: @document_file.esign, esign_data: @document_file.esign_data, file: @document_file.file, origin: @document_file.origin, origin_id: @document_file.origin_id, photo: @document_file.photo, photo_date: @document_file.photo_date, photo_description: @document_file.photo_description, title: @document_file.title } }
    assert_redirected_to document_file_url(@document_file)
  end

  test "should destroy document_file" do
    assert_difference('DocumentFile.count', -1) do
      delete document_file_url(@document_file)
    end

    assert_redirected_to document_files_url
  end
end
