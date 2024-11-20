OpenAI.configure do |config|
    config.access_token = ENV.fetch('OPENAI_ACCESS_TOKEN') do
        Rails.logger.error "Missing OpenAI API Key. Please set the OPENAI_ACCESS_TOKEN environment variable."
        nil
    config.request_timeout = 240
    end
end