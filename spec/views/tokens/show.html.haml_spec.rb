require 'spec_helper'

describe "tokens/show.html.haml" do
  before(:each) do
    assign(:token, Factory(:token))
  end
  it "renders the show token page" do
    render
  end
end
