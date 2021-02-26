require "application_system_test_case"

class IssueChecklistsTest < ApplicationSystemTestCase
  setup do
    @issue_checklist = issue_checklists(:one)
  end

  test "visiting the index" do
    visit issue_checklists_url
    assert_selector "h1", text: "Issue Checklists"
  end

  test "creating a Issue checklist" do
    visit issue_checklists_url
    click_on "New Issue Checklist"

    click_on "Create Issue checklist"

    assert_text "Issue checklist was successfully created"
    click_on "Back"
  end

  test "updating a Issue checklist" do
    visit issue_checklists_url
    click_on "Edit", match: :first

    click_on "Update Issue checklist"

    assert_text "Issue checklist was successfully updated"
    click_on "Back"
  end

  test "destroying a Issue checklist" do
    visit issue_checklists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Issue checklist was successfully destroyed"
  end
end
