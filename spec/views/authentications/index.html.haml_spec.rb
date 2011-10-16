require 'spec_helper'

describe "authentications/index.html.haml" do
  before(:each) do
    login_as_person_with_authentications
  end
  it "renders" do
    render
  end
end
