require 'spec_helper'

describe "tokens/new.html.haml" do
  before(:each) do
    assign(:token, Factory.build(:token))
  end
  it "renders the new token form" do
    render
  end
end
