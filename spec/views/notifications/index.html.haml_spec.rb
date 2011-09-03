require 'spec_helper'

describe "notifications/index.html.haml" do
  before(:each) do
    assign(:notifications, [
      stub_model(Notification,
        :user_id => 1,
        :at_who => "MyText",
        :content => "MyText"
      ),
      stub_model(Notification,
        :user_id => 1,
        :at_who => "MyText",
        :content => "MyText"
      )
    ])
  end

  it "renders a list of notifications" do
    render
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
  end
end
