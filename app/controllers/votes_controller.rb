class VotesController < ApplicationController

	def vote
		@question = Question.find(params[:question_id])
		@user_vote = Vote.new(question_id: @question.id, user_id: current_user.id)
		if @user_vote.save
			if params[:vote_value] == "up"
				@user_vote.vote_num = 1
				@question.vote_count += 1
			else 
				@user_vote.vote_num = 0
				@question.vote_count += -1
			end 
			@question.save!; @user_vote.save!

			respond_to do |format|
				format.js
			end
		else
			@message = "Du kan kun stemme én gang på hvert spørgsmål"
			respond_to do |format|
				format.js { render 'message' }
			end
		end
	end

	def destroy
		@question = Question.find(params[:question_id])
		@vote = Vote.find(params[:vote_id])
						
			if @vote.vote_num == 1
				@question.vote_count -= 1
			else
				@question.vote_count += 1
			end
		@question.save!
		if @vote.destroy
			@user_vote = nil			
			@message = "Din stemme er blevet fjernet"
			respond_to do |format|
				format.js { render 'vote' }
				format.js { render 'message' }
			end
		end
	end
		

end
