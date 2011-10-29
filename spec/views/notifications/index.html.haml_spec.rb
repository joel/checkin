require 'spec_helper'

describe "notifications/index.html.haml" do

  before(:each) do
    5.times { Factory(:notification) }
    assign(:notifications, Notification.order('created_at desc').page("0"))
  end

  it "renders a list of notifications" do
    render
    rendered.should have_content(1.to_s)
    rendered.should have_content("MyText".to_s)
  end

end
