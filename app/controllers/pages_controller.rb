class PagesController < ApplicationController
	def home
		if log_in?

		session[:token] = cookies[:token] if session[:token].empty?

		vk = VkontakteApi::Client.new(session[:token])

		@user = vk.users.get(uid: session[:vk_id], fields: [:screen_name, :photo]).first
		@friends = vk.friends.get
		@photos = vk.photos.get(owner_id: 78141952, album_id: 'saved')

		end
	end

	def index
	end
end
