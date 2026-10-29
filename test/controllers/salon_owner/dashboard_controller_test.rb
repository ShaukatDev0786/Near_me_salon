require "test_helper"

class SalonOwner::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get salon_owner_dashboard_index_url
    assert_response :success
  end
end
