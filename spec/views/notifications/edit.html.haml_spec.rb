require 'spec_helper'

describe "notifications/edit.html.haml" do
  before(:each) do
    @notification = assign(:notification, stub_model(Notification,
      :person_id => 1,
      :at_who => "MyText",
      :content => "MyText"
    ))
  end

  it "renders the edit notification form" do
    render

    rendered.should have_selector("form", :action => notification_path(@notification), :method => "post") do |form|
      form.should have_selector("input#notification_person_id", :name => "notification[person_id]")
      form.should have_selector("textarea#notification_at_who", :name => "notification[at_who]")
      form.should have_selector("textarea#notification_content", :name => "notification[content]")
    end
  end
end
