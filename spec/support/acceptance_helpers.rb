module AcceptanceHelpers

  def login_as_person_with_credits
    @user = Factory(:user)
    ['full day','half day', 'free'].each do |title|
      token_type = Factory(:token_type, :title => title)
      5.times { Factory(:token, :token_type_id => token_type.id, :user => @user, :start_at => nil, :stop_at => nil) }
    end
    visit "/users/sign_in"
    fill_in "user_email", :with => @user.email
    fill_in "user_password", :with => @user.password
    click_button "new_sessions_submit"
  end

end