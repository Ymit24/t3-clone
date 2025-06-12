require "test_helper"

class ChatThreadsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @chat_thread = chat_threads(:one)
  end

  test "should get index" do
    get chat_threads_url
    assert_response :success
  end

  test "should get new" do
    get new_chat_thread_url
    assert_response :success
  end

  test "should create chat_thread" do
    assert_difference("ChatThread.count") do
      post chat_threads_url, params: { chat_thread: { title: "Valid Title" } }
    end

    assert_redirected_to chat_thread_url(ChatThread.last)
  end

  test "should not create chat_thread with invalid title" do
    assert_no_difference("ChatThread.count") do
      post chat_threads_url, params: { chat_thread: { title: "a" } }
    end

    assert_response :unprocessable_entity
  end

  test "should show chat_thread" do
    get chat_thread_url(@chat_thread)
    assert_response :success
  end

  test "should get edit" do
    get edit_chat_thread_url(@chat_thread)
    assert_response :success
  end

  test "should update chat_thread" do
    patch chat_thread_url(@chat_thread), params: { chat_thread: { title: "Updated Title" } }
    assert_redirected_to chat_thread_url(@chat_thread)
  end

  test "should not update chat_thread with invalid title" do
    patch chat_thread_url(@chat_thread), params: { chat_thread: { title: "a" } }
    assert_response :unprocessable_entity
  end

  test "should destroy chat_thread" do
    assert_difference("ChatThread.count", -1) do
      delete chat_thread_url(@chat_thread)
    end

    assert_redirected_to chat_threads_url
  end
end
