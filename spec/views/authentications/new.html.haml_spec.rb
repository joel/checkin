require 'spec_helper'

describe "authentications/new.html.haml" do
  before(:each) do
    assign(:authentication, stub_model(Authentication,
      :user_id => 1,
      :provider => "MyString",
      :uid => "MyString"
    ).as_new_record)
  end

  it "renders new authentication form" do
    render

    rendered.should have_selector("form", :action => authentications_path, :method => "post") do |form|
      form.should have_selector("input#authentication_user_id", :name => "authentication[user_id]")
      form.should have_selector("input#authentication_provider", :name => "authentication[provider]")
      form.should have_selector("input#authentication_uid", :name => "authentication[uid]")
    end
  end
end
