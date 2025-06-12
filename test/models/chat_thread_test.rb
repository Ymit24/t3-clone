# == Schema Information
#
# Table name: chat_threads
#
#  id         :integer          not null, primary key
#  title      :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_chat_threads_on_user_id  (user_id)
#

require "test_helper"

class ChatThreadTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @chat_thread = ChatThread.new(title: "Test Thread", user: @user)
  end

  test "should be valid" do
    assert @chat_thread.valid?
  end

  test "title should be present" do
    @chat_thread.title = "   "
    assert_not @chat_thread.valid?
  end

  test "title should not be too short" do
    @chat_thread.title = "a" * 2
    assert_not @chat_thread.valid?
  end

  test "title should not be too long" do
    @chat_thread.title = "a" * 101
    assert_not @chat_thread.valid?
  end

  test "title should be between 3 and 100 characters" do
    @chat_thread.title = "a" * 3
    assert @chat_thread.valid?

    @chat_thread.title = "a" * 100
    assert @chat_thread.valid?
  end

  test "should belong to a user" do
    @chat_thread.user = nil
    assert_not @chat_thread.valid?
  end
end
