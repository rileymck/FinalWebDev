class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  attr_accessor :message

  # Parse messages from the history field
  def messages
    JSON.parse(history || '{"messages": []}')["messages"]
  rescue JSON::ParserError
    [] # Return an empty array if the JSON is invalid
  end

  # Set a new message and process the chat
  def message=(message)
    updated_messages = messages + [{ 'role' => 'user', 'content' => message }]

    # Fetch the assistant's response with retry logic
    assistant_message = fetch_response_with_backoff(updated_messages)

    # Update the chat history if the assistant's message is valid
    if assistant_message
      self.history = { messages: updated_messages + [{ 'role' => 'assistant', 'content' => assistant_message }] }.to_json
      save!
    end

    assistant_message || "I'm sorry, I couldn't process that."
  end

  private

  # Initialize the OpenAI client
  def client
    OpenAI::Client.new(api_key: ENV['OPENAI_ACCESS_TOKEN'])
  end

  # Fetch response with retry logic
  def fetch_response_with_backoff(messages, max_retries = 3)
    retries = 0

    begin
      response = client.chat(
        parameters: openai_parameters(messages)
      )

      response.dig("choices", 0, "message", "content")
    rescue Faraday::TooManyRequestsError
      if retries < max_retries
        sleep(2**retries) # Exponential backoff
        retries += 1
        retry
      else
        Rails.logger.error("Max retries reached. OpenAI rate limit exceeded.")
        nil
      end
    rescue OpenAI::Error => e
      Rails.logger.error("OpenAI API error: #{e.message}")
      nil
    end
  end

  # Define parameters for OpenAI
  def openai_parameters(messages)
    {
      model: 'gpt-3.5-turbo',
      messages: messages,
      temperature: 0.7,
      max_tokens: 500,
      top_p: 1,
      frequency_penalty: 0.0,
      presence_penalty: 0.6
    }
  end
end
