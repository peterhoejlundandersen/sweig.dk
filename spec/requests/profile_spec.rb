require 'rails_helper'

RSpec.describe "UserProfile" do 
	let(:user) {create(:user, :works)}
	let(:active_user) {create(:user, :works)}

	it "should not be possible for another user to visit the user-profile pages" do
		active_user = create(:user) # The user trying to visit 
		log_user_in active_user
		%w(user_biblo user_saved_works user_my_works new_user_work).each do |path|
			visit eval("#{path}_path(user.friendly_id)") 
			expect(page).to have_current_path(user_path(user.friendly_id))
			expect(page).to have_content("Du kan ikke besøge")
		end 
		visit edit_user_work_path(user.friendly_id, user.works.first.friendly_id) # Opret værk
		expect(page).to have_current_path(user_path(user.friendly_id))
		expect(page).to have_content("Du kan ikke besøge")
	end

	it "biblo should be updated with save-message when saving work" do
		log_user_in active_user
		first_work = user.works.first
		visit user_work_path(user.friendly_id, first_work.friendly_id)
		click_link "GEM"
		within(".show-navbar") do
			expect(page).to have_content("'#{first_work.title}' er nu gemt")
		end
		visit user_biblo_path(active_user.friendly_id)
		within(".biblo-wrapper") do
			expect(page).to have_content("Du har gemt #{first_work.title}")
		end
	end


	
end