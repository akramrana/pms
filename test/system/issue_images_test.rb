require "application_system_test_case"

class IssueImagesTest < ApplicationSystemTestCase
  setup do
    @issue_image = issue_images(:one)
  end

  test "visiting the index" do
    visit issue_images_url
    assert_selector "h1", text: "Issue Images"
  end

  test "creating a Issue image" do
    visit issue_images_url
    click_on "New Issue Image"

    click_on "Create Issue image"

    assert_text "Issue image was successfully created"
    click_on "Back"
  end

  test "updating a Issue image" do
    visit issue_images_url
    click_on "Edit", match: :first

    click_on "Update Issue image"

    assert_text "Issue image was successfully updated"
    click_on "Back"
  end

  test "destroying a Issue image" do
    visit issue_images_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Issue image was successfully destroyed"
  end
end
