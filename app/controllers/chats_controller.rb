class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: %i[ edit update destroy ]
  layout "chat"

  # GET /chats or /chats.json
  def index
    @chats = current_user.chats.order(created_at: :desc)
    if @chats.any?
      redirect_to chat_url(@chats.first)
    end
  end

  # GET /chats/1 or /chats/1.json
  def show
    @chat = Chat.find(params[:id])
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
    # Fetch the user's chats and determine the next number
    last_chat = current_user.chats.order(:created_at).last
    next_number = last_chat ? last_chat.name.scan(/\d+/).last.to_i + 1 : 1
    
    # Create the new chat
    @chat = current_user.chats.build(
      name: "Chat #{next_number}",
      history: { messages: [] }.to_json
    )

    if @chat.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @chat, notice: 'Chat was successfully created.' }
      end
    else
      render :new, status: :unprocessable_entity
    end












    #last_chat_number = current_user.chats.maximum(:id) || 0
    #next_chat_number = last_chat_number + 1

    #@chat = current_user.chats.build(name: "Chat #{next_chat_number}", history: { messages: [] })

    #respond_to do |format|
      #if @chat.save
        #format.html { redirect_to @chat, notice: "Chat was successfully created." }
        #format.turbo_stream { render turbo_stream: turbo_stream.prepend("user-chats", partial: "chats/chat", locals: { chat: @chat }) }
      #else
        #format.html { render :new, status: :unprocessable_entity }
        #format.turbo_stream { render turbo_stream: turbo_stream.replace("new_chat_form", partial: "chats/form", locals: { chat: @chat }) }
      #end
    #end
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to @chat, notice: "Chat was successfully updated." }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat = current_user.chats.find(params[:id]) # Ensures chat belongs to current_user
    if @chat.destroy
      respond_to do |format|
        format.html { redirect_to chats_path, notice: "Chat was successfully deleted." }
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@chat) }
      end
    else
      respond_to do |format|
        format.html { redirect_to chats_path, alert: "Failed to delete chat." }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("user-chats", partial: "chats/chat", locals: { chat: @chat }) }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      Rails.logger.debug "Chat ID: #{params[:id]}"
      Rails.logger.debug "Available Chats: #{current_user.chats.pluck(:id)}"
      @chat = current_user.chats.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:user_id, :history, :q_and_a)
    end
end
