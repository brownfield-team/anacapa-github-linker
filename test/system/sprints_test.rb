require "application_system_test_case"

class SprintsTest < ApplicationSystemTestCase
  setup do
    @sprint = sprints(:one)
  end

  test "visiting the index" do
    visit sprints_url
    assert_selector "h1", text: "Sprints"
  end

  test "creating a Sprint" do
    visit sprints_url
    click_on "New Sprint"

    fill_in "Course", with: @sprint.course_id
    fill_in "End date", with: @sprint.end_date
    fill_in "Name", with: @sprint.name
    fill_in "Start date", with: @sprint.start_date
    click_on "Create Sprint"

    assert_text "Sprint was successfully created"
    click_on "Back"
  end

  test "updating a Sprint" do
    visit sprints_url
    click_on "Edit", match: :first

    fill_in "Course", with: @sprint.course_id
    fill_in "End date", with: @sprint.end_date
    fill_in "Name", with: @sprint.name
    fill_in "Start date", with: @sprint.start_date
    click_on "Update Sprint"

    assert_text "Sprint was successfully updated"
    click_on "Back"
  end

  test "destroying a Sprint" do
    visit sprints_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sprint was successfully destroyed"
  end
end
