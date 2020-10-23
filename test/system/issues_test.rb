require "application_system_test_case"

class IssuesTest < ApplicationSystemTestCase
  setup do
    @issue = issues(:one)
  end

  test "visiting the index" do
    visit issues_url
    assert_selector "h1", text: "Issues"
  end

  test "creating a Issue" do
    visit issues_url
    click_on "New Issue"

    fill_in "Addedtime", with: @issue.addedTime
    fill_in "Assignee", with: @issue.assignee
    fill_in "Description", with: @issue.description
    fill_in "Duedate", with: @issue.dueDate
    fill_in "Environment", with: @issue.environment
    fill_in "Issuetypeid", with: @issue.issueTypeId
    fill_in "Originalestimate", with: @issue.originalEstimate
    fill_in "Prioritypeid", with: @issue.prioritypeId
    fill_in "Projectid", with: @issue.projectId
    fill_in "Remainestimate", with: @issue.remainEstimate
    fill_in "Reporter", with: @issue.reporter
    fill_in "Summary", with: @issue.summary
    click_on "Create Issue"

    assert_text "Issue was successfully created"
    click_on "Back"
  end

  test "updating a Issue" do
    visit issues_url
    click_on "Edit", match: :first

    fill_in "Addedtime", with: @issue.addedTime
    fill_in "Assignee", with: @issue.assignee
    fill_in "Description", with: @issue.description
    fill_in "Duedate", with: @issue.dueDate
    fill_in "Environment", with: @issue.environment
    fill_in "Issuetypeid", with: @issue.issueTypeId
    fill_in "Originalestimate", with: @issue.originalEstimate
    fill_in "Prioritypeid", with: @issue.prioritypeId
    fill_in "Projectid", with: @issue.projectId
    fill_in "Remainestimate", with: @issue.remainEstimate
    fill_in "Reporter", with: @issue.reporter
    fill_in "Summary", with: @issue.summary
    click_on "Update Issue"

    assert_text "Issue was successfully updated"
    click_on "Back"
  end

  test "destroying a Issue" do
    visit issues_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Issue was successfully destroyed"
  end
end
