require "test_helper"

class DiscoverSalonsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get discover_salons_index_url
    assert_response :success
  end

  test "should get show" do
    get discover_salons_show_url
    assert_response :success
  end
end
