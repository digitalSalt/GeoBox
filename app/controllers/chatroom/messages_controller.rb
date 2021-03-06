module Chatroom
	class MessagesController < ApplicationController
		skip_before_action :verify_authenticity_token, only: [:create]
		before_action :define_chatting
		# before_action :set_room, only: [:index]
		# GET /messages/rooms/:room_id
		def index
			session[:room_id] = params[:room_id]
			@messages = Message.all.where(room_id: session[:room_id])
		end

		# POST /messages
		# POST /messages.json
		def create
			message = message_params
			message[:room_id] = session[:room_id]
			@message = Message.create!(message)
		end

		private
			# Never trust parameters from the scary internet, only allow the white list through.
			def message_params
				params.require(:message).permit(:content, :username)
			end

			def define_chatting
				@chatting = true;
			end

			def set_room
				@room = Room.find(params[:room_id])
			end
	end
end
