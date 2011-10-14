require 'spec_helper'

describe "authentications/index.html.haml" do
  before(:each) do
    assign(:authentications, [
      stub_model(Authentication,
        :user_id => 1,
        :provider => "Provider",
        :uid => "Uid"
      ),
      stub_model(Authentication,
        :user_id => 1,
        :provider => "Provider",
        :uid => "Uid"
      )
    ])
  end

  it "renders a list of authentications" do
    render
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Provider".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Uid".to_s, :count => 2)
  end
end
