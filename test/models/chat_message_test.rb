# == Schema Information
#
# Table name: chat_messages
#
#  id             :integer          not null, primary key
#  content        :text
#  chat_thread_id :integer          not null
#  user_id        :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_chat_messages_on_chat_thread_id  (chat_thread_id)
#  index_chat_messages_on_user_id         (user_id)
#

require "test_helper"

class ChatMessageTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @chat_thread = chat_threads(:one)
    @chat_message = ChatMessage.new(
      content: "Test message",
      chat_thread: @chat_thread,
      user: @user
    )
  end

  test "should be valid" do
    assert @chat_message.valid?
  end

  test "content should be present" do
    @chat_message.content = "   "
    assert_not @chat_message.valid?
  end

  test "content should not be too long" do
    @chat_message.content = "a" * 1001
    assert_not @chat_message.valid?
  end

  test "content should be between 1 and 1000 characters" do
    @chat_message.content = "a"
    assert @chat_message.valid?

    @chat_message.content = "a" * 1000
    assert @chat_message.valid?
  end

  test "should belong to a chat thread" do
    @chat_message.chat_thread = nil
    assert_not @chat_message.valid?
  end

  test "should belong to a user" do
    @chat_message.user = nil
    assert_not @chat_message.valid?
  end
end
