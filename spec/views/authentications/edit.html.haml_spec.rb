require 'spec_helper'

describe "authentications/edit.html.haml" do
  before(:each) do
    @authentication = assign(:authentication, stub_model(Authentication,
      :user_id => 1,
      :provider => "MyString",
      :uid => "MyString"
    ))
  end

  it "renders the edit authentication form" do
    render

    rendered.should have_selector("form", :action => authentication_path(@authentication), :method => "post") do |form|
      form.should have_selector("input#authentication_user_id", :name => "authentication[user_id]")
      form.should have_selector("input#authentication_provider", :name => "authentication[provider]")
      form.should have_selector("input#authentication_uid", :name => "authentication[uid]")
    end
  end
end
