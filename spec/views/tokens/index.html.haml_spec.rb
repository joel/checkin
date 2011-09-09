require 'spec_helper'

describe "tokens/index.html.haml" do
  before(:each) do
    5.times { Factory(:token) }
    assign(:tokens, Token.order('created_at desc'))
  end
  it "renders the index token page" do
    render
  end
end
