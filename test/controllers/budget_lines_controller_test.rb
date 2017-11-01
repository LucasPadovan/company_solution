require 'test_helper'

class BudgetLinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @budget_line = budget_lines(:one)
  end

  test "should get index" do
    get budget_lines_url
    assert_response :success
  end

  test "should get new" do
    get new_budget_line_url
    assert_response :success
  end

  test "should create budget_line" do
    assert_difference('BudgetLine.count') do
      post budget_lines_url, params: { budget_line: { budget_id: @budget_line.budget_id, currency: @budget_line.currency, position: @budget_line.position, price_change: @budget_line.price_change, product_id: @budget_line.product_id, tax_rate: @budget_line.tax_rate, unit: @budget_line.unit, unit_price: @budget_line.unit_price } }
    end

    assert_redirected_to budget_line_url(BudgetLine.last)
  end

  test "should show budget_line" do
    get budget_line_url(@budget_line)
    assert_response :success
  end

  test "should get edit" do
    get edit_budget_line_url(@budget_line)
    assert_response :success
  end

  test "should update budget_line" do
    patch budget_line_url(@budget_line), params: { budget_line: { budget_id: @budget_line.budget_id, currency: @budget_line.currency, position: @budget_line.position, price_change: @budget_line.price_change, product_id: @budget_line.product_id, tax_rate: @budget_line.tax_rate, unit: @budget_line.unit, unit_price: @budget_line.unit_price } }
    assert_redirected_to budget_line_url(@budget_line)
  end

  test "should destroy budget_line" do
    assert_difference('BudgetLine.count', -1) do
      delete budget_line_url(@budget_line)
    end

    assert_redirected_to budget_lines_url
  end
end
