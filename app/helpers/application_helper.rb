module ApplicationHelper
	def if_active_helper path
		"active" if current_path == path
	end

	def if_active_link_helper path
		"active-link" if current_page?(path)
	end



	def is_current_user?
		if user_signed_in?
		current_user == @user
		end
	end

	def set_title_helper
		default = "Sweig"
		if @page_title
			default + " | " + @page_title
		else
			default
		end
	end

	def alert_notice_helper
		if flash[:notice]
			content_tag :div, flash[:notice], class: "notice text-center"
		elsif flash[:error]
			content_tag :div, flash[:error], class: "alert text-center"
		end
	end
	
	def session_helper_social
		if session[:social] 
			social_message = "Tak fordi du besøger os fra #{session[:social]}"
			content_tag :div, social_message, class: "callout succes text-center"
		end
	end

	# For DEVISE MODAL
	def resource_name
	   :user
	 end

	 def resource
	   @resource ||= User.new
	 end

	 def devise_mapping
	   @devise_mapping ||= Devise.mappings[:user]
	 end

end
