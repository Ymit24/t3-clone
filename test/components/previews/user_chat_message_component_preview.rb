# frozen_string_literal: true

class UserChatMessageComponentPreview < ViewComponent::Preview
  def default
    render UserChatMessageComponent.new(
      msg: "Hello! I need help with my code."
    )
  end

  def long_message
    render UserChatMessageComponent.new(
      msg: "I'm working on a Rails application and I need to implement a feature that allows users to upload files and process them in the background. Can you help me with that?"
    )
  end

  def with_code
    render UserChatMessageComponent.new(
      msg: "Here's my current code:\n\n```ruby\nclass User < ApplicationRecord\n  has_many :posts\nend\n```"
    )
  end
end 