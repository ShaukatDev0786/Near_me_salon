require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "visiting the home page" do
    visit root_path

    assert_text "NearMe Salon"
    assert_text "Find the best salon"
  end
end
