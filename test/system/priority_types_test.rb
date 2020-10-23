require "application_system_test_case"

class PriorityTypesTest < ApplicationSystemTestCase
  setup do
    @priority_type = priority_types(:one)
  end

  test "visiting the index" do
    visit priority_types_url
    assert_selector "h1", text: "Priority Types"
  end

  test "creating a Priority type" do
    visit priority_types_url
    click_on "New Priority Type"

    fill_in "Prioritytypename", with: @priority_type.priorityTypeName
    click_on "Create Priority type"

    assert_text "Priority type was successfully created"
    click_on "Back"
  end

  test "updating a Priority type" do
    visit priority_types_url
    click_on "Edit", match: :first

    fill_in "Prioritytypename", with: @priority_type.priorityTypeName
    click_on "Update Priority type"

    assert_text "Priority type was successfully updated"
    click_on "Back"
  end

  test "destroying a Priority type" do
    visit priority_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Priority type was successfully destroyed"
  end
end
