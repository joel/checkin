require 'spec_helper'

describe "notifications/show.html.haml" do
  
  before(:each) do
    @notification = assign(:notification, Factory(:notification))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain(1.to_s)
    rendered.should contain("MyText".to_s)
    rendered.should contain("MyText".to_s)
  end
  
end
