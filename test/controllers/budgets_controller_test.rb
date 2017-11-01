require 'test_helper'

class BudgetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @budget = budgets(:one)
  end

  test "should get index" do
    get budgets_url
    assert_response :success
  end

  test "should get new" do
    get new_budget_url
    assert_response :success
  end

  test "should create budget" do
    assert_difference('Budget.count') do
      post budgets_url, params: { budget: { body_image: @budget.body_image, contact: @budget.contact, date: @budget.date, destinatary: @budget.destinatary, firm_id: @budget.firm_id, from: @budget.from, header_image: @budget.header_image, number: @budget.number, pdf_file: @budget.pdf_file, title: @budget.title, to: @budget.to } }
    end

    assert_redirected_to budget_url(Budget.last)
  end

  test "should show budget" do
    get budget_url(@budget)
    assert_response :success
  end

  test "should get edit" do
    get edit_budget_url(@budget)
    assert_response :success
  end

  test "should update budget" do
    patch budget_url(@budget), params: { budget: { body_image: @budget.body_image, contact: @budget.contact, date: @budget.date, destinatary: @budget.destinatary, firm_id: @budget.firm_id, from: @budget.from, header_image: @budget.header_image, number: @budget.number, pdf_file: @budget.pdf_file, title: @budget.title, to: @budget.to } }
    assert_redirected_to budget_url(@budget)
  end

  test "should destroy budget" do
    assert_difference('Budget.count', -1) do
      delete budget_url(@budget)
    end

    assert_redirected_to budgets_url
  end
end
