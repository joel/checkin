require 'spec_helper'

describe "tokens/edit.html.haml" do
  before(:each) do
    assign(:token, Factory(:token))
  end
  it "renders the edit token form" do
    render
  end
end  