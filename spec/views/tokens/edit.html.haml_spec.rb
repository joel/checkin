require 'spec_helper'

describe "tokens/edit.html.haml" do
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

  it "renders the edit token form" do
    render

    rendered.should have_selector("form", :action => token_path(@token), :method => "post") do |form|
      form.should have_selector("input#token_token_type_id", :name => "token[token_type_id]")
      form.should have_selector("input#token_person_id", :name => "token[person_id]")
      form.should have_selector("input#token_cost", :name => "token[cost]")
      form.should have_selector("input#token_used", :name => "token[used]")
      form.should have_selector("input#token_motivation_id", :name => "token[motivation_id]")
      form.should have_selector("input#token_checkin_owner_id", :name => "token[checkin_owner_id]")
      form.should have_selector("input#token_token_owner_id", :name => "token[token_owner_id]")
    end
  end
end
