module ApplicationHelper

	def strip_html_work_helper html_string, length=80
		truncate(strip_tags(html_string.gsub("<br />", " ").html_safe), length: length)
	end

	def link_to_user_helper user, string, classes=""
		if user_signed_in? && current_user.id == user.id
			link_to string, user_biblo_path(user.friendly_id), class: classes
		else
			link_to string, user_path(user.friendly_id), class: classes
		end
	end

	def footer_size_helper
		current_user ? "col-md-3" : "col-md-4"
	end
	def if_active_helper path
		"active" if current_path == path
	end

	def if_active_link_helper path
		if current_page?(path)
			"active-link"
		end
	end

	def is_current_user?
		if user_signed_in?
		current_user.id == @user.id
		end
	end

	def set_title_helper
		default = "Sweig"
		@head_title ? default + " | " + @head_title : default
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
