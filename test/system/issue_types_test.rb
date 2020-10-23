require "application_system_test_case"

class IssueTypesTest < ApplicationSystemTestCase
  setup do
    @issue_type = issue_types(:one)
  end

  test "visiting the index" do
    visit issue_types_url
    assert_selector "h1", text: "Issue Types"
  end

  test "creating a Issue type" do
    visit issue_types_url
    click_on "New Issue Type"

    fill_in "Issuetypename", with: @issue_type.issueTypeName
    click_on "Create Issue type"

    assert_text "Issue type was successfully created"
    click_on "Back"
  end

  test "updating a Issue type" do
    visit issue_types_url
    click_on "Edit", match: :first

    fill_in "Issuetypename", with: @issue_type.issueTypeName
    click_on "Update Issue type"

    assert_text "Issue type was successfully updated"
    click_on "Back"
  end

  test "destroying a Issue type" do
    visit issue_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Issue type was successfully destroyed"
  end
end
