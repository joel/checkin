require 'spec_helper'

describe "tokens/index.html.haml" do
  before(:each) do
    assign(:tokens, [
      stub_model(Token,
        :token_type_id => 1,
        :person_id => 1,
        :cost => "9.99",
        :used => false,
        :motivation_id => 1,
        :checkin_owner_id => 1,
        :token_owner_id => 1
      ),
      stub_model(Token,
        :token_type_id => 1,
        :person_id => 1,
        :cost => "9.99",
        :used => false,
        :motivation_id => 1,
        :checkin_owner_id => 1,
        :token_owner_id => 1
      )
    ])
  end

  it "renders a list of tokens" do
    render
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "9.99".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => false.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
  end
end
