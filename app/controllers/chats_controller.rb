class ChatsController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_chat, only: [:destroy]
  before_action :set_chat, only: %i[ edit update destroy ]
  layout "chat"

  # GET /chats or /chats.json
  def index
    @chats = current_user.chats.where(deleted_at: nil).order(created_at: :desc)
  end

  # GET /chats/1 or /chats/1.json
  def show
    @chat = Chat.find(params[:id])
    # Parse messages from the `history` JSON field
    @messages = JSON.parse(@chat.history)["messages"] || []

    # Fetch the list of chats to display in the chat list
    @chats = current_user.chats.order(created_at: :desc)

    Rails.logger.debug "Chat History: #{@chat.history}"

  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
    @chat = current_user.chats.find(params[:id])
    render layout: false # This prevents the layout from rendering
  end

  # POST /chats or /chats.json
  def create
    # Fetch the user's last chat and determine the next number
    last_chat = current_user.chats.order(:created_at).last
    last_chat_name = last_chat&.name || ""  # Use an empty string if name is nil
    next_number = last_chat_name.scan(/\d+/).last.to_i + 1

    @chat = current_user.chats.build(
      name: "Chat #{next_number}",
      history: { messages: [] }.to_json
    )

    if @chat.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.append('chat_list', partial: 'chats/chat', locals: { chat: @chat }) }
        format.html { redirect_to @chat, notice: 'Chat was successfully created.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end


  require 'openai'

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    chat = Chat.find(params[:id])

    # Get the user's message
    user_message = params[:chat][:message]

    # Query OpenAI for a response
    assistant_message = query_openai_with_backoff(user_message)

    if assistant_message
      chat.message = assistant_message
      if chat.save
        flash[:notice] = "Assistant responded: #{assistant_message}"
      else
        flash[:alert] = "Failed to save the assistant's response. Please try again."
      end
    else
      flash[:alert] = "Unable to process the message. Please try again later."
    end

    redirect_to chat_path(chat)
  end





  private

  def query_openai_with_backoff(prompt, retries = 3)
    client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY']) # Ensure the API key is set correctly
  
    begin
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo", # Use the correct model for chat-based completions
          messages: [{ role: "user", content: prompt }],
          max_tokens: 150
        }
      )
      response.dig("choices", 0, "message", "content") # Extract the assistant's response
    rescue OpenAI::Error => e
      if retries.positive?
        sleep(2 ** (3 - retries)) # Exponential backoff
        retries -= 1
        retry
      else
        Rails.logger.error("OpenAI API error: #{e.message}")
        nil
      end
    end
  end




  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy
    # You can add a debug log to verify
    Rails.logger.debug "Chat #{@chat.id} deleted"

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to chats_url, notice: 'Chat was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      #@chat = Chat.find(params[:id])
      Rails.logger.debug "Chat ID: #{params[:id]}"
      Rails.logger.debug "Available Chats: #{current_user.chats.pluck(:id)}"
      @chat = current_user.chats.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:history, :q_and_a, :user_id)
    end


    def ask
      user_input = params
        [:question]
  
      # Query OpenAI for a response
      response = OpenAIClient.completions(
        engine: "text-davinci-003",
        prompt: user_input,
        max_tokens: 150
      )
  
      render json: { answer: response['choices'].first['text'].strip }
    end
end
