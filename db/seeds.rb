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
LlmModel.create!(name: "Gemma", provider: "openrouter", model: "google/gemma-3n-e4b-it:free", can_search: false, can_reason: false)
LlmModel.create!(name: "Llama 3.3", provider: "openrouter", model: "meta-llama/llama-3.3-8b-instruct:free", can_search: false, can_reason: false)
LlmModel.create!(name: "Gemini Flash 2.5", provider: "openrouter", model: "google/gemini-2.5-flash-preview-05-20", can_search: true, can_reason: true)
LlmModel.create!(name: "GPT 4o", provider: "openai", model: "gpt-4o", can_search: false, can_reason: false)
LlmModel.create!(name: "GPT 4o Mini", provider: "openai", model: "gpt-4o-mini", can_search: false, can_reason: false)

end
