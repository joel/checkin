require 'spec_helper'

describe "notifications/index.html.haml" do
  
  before(:each) do
    5.times { Factory(:notification) }
    assign(:notifications, Notification.order('created_at desc').page("0"))
  end

  it "renders a list of notifications" do
    render
    rendered.should contain(1.to_s)
    rendered.should contain("MyText".to_s)
  end
  
end
