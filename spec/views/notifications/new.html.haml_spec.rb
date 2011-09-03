require 'spec_helper'

describe "notifications/new.html.haml" do
  before(:each) do
    assign(:notification, stub_model(Notification,
      :user_id => 1,
      :at_who => "MyText",
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new notification form" do
    render

    rendered.should have_selector("form", :action => notifications_path, :method => "post") do |form|
      form.should have_selector("input#notification_user_id", :name => "notification[user_id]")
      form.should have_selector("textarea#notification_at_who", :name => "notification[at_who]")
      form.should have_selector("textarea#notification_content", :name => "notification[content]")
    end
  end
end
