require 'test_helper'

class InviteControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get request" do
    get :request
    assert_response :success
  end

  test "should get claim" do
    get :claim
    assert_response :success
  end

end
