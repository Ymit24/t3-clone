# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ApplicationRecord.transaction do
User.destroy_all

LlmModel.destroy_all
LlmModel.create!(name: "OR Gemini Flash 2.5", provider: "openrouter", model: "google/gemini-2.5-flash-preview-05-20", can_search: true, can_reason: true)
LlmModel.create!(name: "OR Qwen3 32B", provider: "openrouter", model: "qwen/qwen3-32b-04-28", can_search: true, can_reason: true)
LlmModel.create!(name: "OR Qwen3 30B A3B", provider: "openrouter", model: "qwen/qwen3-30b-a3b-04-28", can_search: true, can_reason: true)
LlmModel.create!(name: "OR Mistral Large", provider: "openrouter", model: "mistralai/mistral-large", can_search: true, can_reason: true)
LlmModel.create!(name: "OR Mixtral 8x22B", provider: "openrouter", model: "mistralai/mixtral-8x22b", can_search: true, can_reason: true)
LlmModel.create!(name: "OR Claude 3 Opus", provider: "openrouter", model: "anthropic/claude-3-opus-20240229", can_search: true, can_reason: true)
LlmModel.create!(name: "OR Claude 3 Sonnet", provider: "openrouter", model: "anthropic/claude-3-sonnet-20240229", can_search: true, can_reason: true)
LlmModel.create!(name: "OR Claude 3 Haiku", provider: "openrouter", model: "anthropic/claude-3-haiku-20240307", can_search: true, can_reason: true)
LlmModel.create!(name: "OR Llama 3 70B", provider: "openrouter", model: "meta-llama/llama-3-70b-instruct", can_search: false, can_reason: false)
LlmModel.create!(name: "OR DeepSeek V2", provider: "openrouter", model: "deepseek-ai/deepseek-v2-chat", can_search: true, can_reason: true)

LlmModel.create!(name: "OAI GPT 4o", provider: "openai", model: "gpt-4o", can_search: false, can_reason: false)
LlmModel.create!(name: "OAI GPT 4o Mini", provider: "openai", model: "gpt-4o-mini", can_search: false, can_reason: false)
LlmModel.create!(name: "OAI GPT-4.1", provider: "openai", model: "gpt-4.1", can_search: false, can_reason: false)
LlmModel.create!(name: "OAI GPT-4.1 Mini", provider: "openai", model: "gpt-4.1-mini", can_search: false, can_reason: false)
LlmModel.create!(name: "OAI GPT-4.1 Nano", provider: "openai", model: "gpt-4.1-nano", can_search: false, can_reason: false)
LlmModel.create!(name: "OAI GPT-4 Turbo", provider: "openai", model: "gpt-4-turbo", can_search: false, can_reason: false)
LlmModel.create!(name: "OAI GPT-4", provider: "openai", model: "gpt-4", can_search: false, can_reason: false)
LlmModel.create!(name: "OAI GPT-3.5 Turbo", provider: "openai", model: "gpt-3.5-turbo", can_search: false, can_reason: false)

end
