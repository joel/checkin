require 'spec_helper'

describe "notifications/new.html.haml" do
  before(:each) do
    assign(:notification, Factory.build(:notification))
  end
  it "renders new notification form" do
    render
    rendered.should have_selector("form", :action => notifications_path, :method => "post") do |form|
      form.should have_selector("input#notification_user_id", :name => "notification[user_id]")
      form.should have_selector("textarea#notification_content", :name => "notification[content]")
    end
  end
end
