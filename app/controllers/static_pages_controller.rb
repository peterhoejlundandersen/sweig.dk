class StaticPagesController < ApplicationController
	before_action :is_user_signed_in?, only: [:log_in, :oprettelse]
	def index
		@newest_works = Work.published_works.limit(8)		
	end

	def find
		@newest_works = Work.limit(8)
		@most_read_works = Work.limit(8).order(:views.length)
		@numbers = numbers
	end

	def number_of_works
		# the second param decide what the name of the variable is
		instance_variable_set("@#{params[:method_name]}", Work.limit(params[:number_of_newest].to_i))
		@most_read_works = @most_read_works.order(:views.length) if @most_read_works 
		respond_to do |format|
			format.js {render params[:method_name]}
		end
	end
	def search
		published_work = Work.where(status: 1)
		@users = User.search(params[:search]).order(created_at: :desc).limit(12) 
		@works = published_work.search(params[:search]).order(created_at: :desc).limit(12)
		respond_to do |format|
			format.js
			format.html
		end		
	end

	def log_in;end

	def oprettelse; end

	def nyt
		@questions = Question.all
	end

		
	def laes 

		published_work = Work.where(status: 1)
		@works = published_work.order(created_at: :desc).limit(12)
		@users = User.order(created_at: :desc).limit(12)

		respond_to do |format|
			format.js
			format.html
		end
	end

	def kontakt

		KontaktMailer.kontakt(params[:email], params[:besked], params[:emne]).deliver

		flash[:notice] = "Din besked '#{params[:emne]}' er blevet sendt"
		redirect_to root_path
	end

	def numbers
		%w(8 16 32 64)
	end

	private

	def is_user_signed_in?
		if user_signed_in?
			flash[:notice] = "Du er allerede logget ind"
			redirect_to user_path(current_user.id)
		end
	end
end
