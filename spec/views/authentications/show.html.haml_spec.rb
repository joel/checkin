require 'spec_helper'

describe "authentications/show.html.haml" do
  before(:each) do
    @authentication = assign(:authentication, stub_model(Authentication,
      :user_id => 1,
      :provider => "Provider",
      :uid => "Uid"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain(1.to_s)
    rendered.should contain("Provider".to_s)
    rendered.should contain("Uid".to_s)
  end
end
