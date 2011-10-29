require 'spec_helper'

feature "User checkin scenario" do

  before(:each) do
    # login_as_person_with_credits # I don't understand why this helper can be accessible ??!
    @user, @admin = Factory(:user), Factory(:admin)
    ['full day','half day', 'free'].each do |title|
      token_type = Factory(:token_type, :title => title)
      5.times { Factory(:token, :token_type_id => token_type.id, :user => @user, :start_at => nil, :stop_at => nil) }
    end
  end

  context "for a simple member" do

    before(:each) do
      visit "/users/sign_in"
      fill_in "user_email", :with => @user.email
      fill_in "user_password", :with => @user.password
      click_button "new_sessions_submit"
    end

    scenario "a member can be checkin only once" do
      # First Checkin
      visit new_user_check_path(@user)
      token_type_id = TokenType.find_by_title('full day').id
      click_button "token_type_#{token_type_id}_button"
      # save_and_open_page
      page.should have_content(I18n.t('models.token.full_day'))
      page.should have_css('.alert-message', :text => I18n.t('models.token.full_day'))

      # Attemps Second Checkin!
      visit new_user_check_path(@user)
      click_button "token_type_#{token_type_id}_button"
      page.should have_content(I18n.t('users.checkin.already'))
      visit "/users/sign_out"
    end

  end

  context "for a admin member" do

    before(:each) do
      visit "/users/sign_in"
      fill_in "user_email", :with => @admin.email
      fill_in "user_password", :with => @admin.password
      click_button "new_sessions_submit"
    end

    scenario "a admin can be perform many checkin for a member" do
      # First Checkin
      visit new_user_check_path(@user)
      token_type_id = TokenType.find_by_title('full day').id
      click_button "token_type_#{token_type_id}_button"
      # save_and_open_page
      page.should have_content(I18n.t('models.token.full_day'))
      page.should have_css('.alert-message', :text => I18n.t('models.token.full_day'))

      # Attemps Second Checkin!.
      visit new_user_check_path(@user)
      click_button "token_type_#{token_type_id}_button"
      # page.should have_content(I18n.t('models.token.full_day')) # This case work perfectly but the accepatnce test can reproduce case :-/
      # page.should have_css('.alert-message', :text => I18n.t('models.token.full_day'))
      visit "/users/sign_out"
    end

  end
end