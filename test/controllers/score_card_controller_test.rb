require 'test_helper'

class ScoreCardControllerTest < ActionController::TestCase
  test "Should get" do
    get :new
    assert_response :success
  end

  test "Should Post" do
    get :new
    assert_response :success
  end

  test "Should get score" do
    get(:new, {"Frame1_bowl1" => 3, "Frame1_bowl2" => 5})
    assert_equal(assigns["scores"][0], 8)
  end

  test "Should get error in first row" do
    post(:new, {"Frame1_bowl1" => 3, "Frame1_bowl2" => 8})
    assert_equal(assigns["first_error"], 0)
    assert_equal(assigns["error_val"][0], "has-error")
  end

  test "Strike Score" do
    post(:new, {"Frame1_bowl1" => 3, "Frame1_bowl2" => 7,
                "Frame2_bowl1" => 7, "Frame2_bowl2" => 1})
    assert_equal(assigns["scores"][0], 17)
    assert_equal(assigns["scores"][1], 25)
  end

  test "Last Frame strike" do
    post(:new, {"Frame10_bowl1" => 10, "Frame10_bowl2" => 2,
                "Frame10_bowl3" => 10})
    assert_equal(assigns["scores"][9], 22)
  end
end
