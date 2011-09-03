require 'spec_helper'

describe "tokens/show.html.haml" do
  before(:each) do
    @token = assign(:token, stub_model(Token,
      :token_type_id => 1,
      :person_id => 1,
      :cost => "9.99",
      :used => false,
      :motivation_id => 1,
      :checkin_owner_id => 1,
      :token_owner_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain(1.to_s)
    rendered.should contain(1.to_s)
    rendered.should contain("9.99".to_s)
    rendered.should contain(false.to_s)
    rendered.should contain(1.to_s)
    rendered.should contain(1.to_s)
    rendered.should contain(1.to_s)
  end
end
