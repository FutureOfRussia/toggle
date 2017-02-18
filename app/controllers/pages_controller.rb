class PagesController < ApplicationController

	def index
	end

	def home
		if log_in?
			session[:token] = cookies[:token] if !session[:token].present?
			@vk = VkontakteApi::Client.new(session[:token])
			$current_user = @vk.users.get(uid: session[:vk_id], 
										fields: [:screen_name, :photo, :counters]).first
			$friends = @vk.friends.get(order: 'random', fields: [:screen_name, :name, :photo])
		
			$friends.items.each do |item|
				friend_id = item.id
				@albums = @vk.photos.getAlbums(owner_id: friend_id, need_system: 1)
				@items = @albums.items
				@items.each do |item|
					@ch = true if item.has_value?(-15)
				end
				item[:check] = true if @ch != true
			end

			$photos = @vk.photos.get(uid: session[:vk_id], album_id: 'saved')
		end
	end

	def search
		search = params[:search]
		@vk = VkontakteApi::Client.new(session[:token])
		$search_friends = @vk.friends.search(q: search, fields: [:screen_name, :name, :photo])
		respond_to do |format|
			format.js
		end	
	end

	def show
		friend_id = params[:id]
		@friend = @vk.users.get(uid: friend_id, fields: [:screen_name, :name, :photo])
		@friend_photos = @vk.photos.get(owner_id: friend_id, album_id: 'saved')
	end

end
