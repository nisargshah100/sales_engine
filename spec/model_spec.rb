require 'spec_helper'

describe SalesEngine::Model do
  let(:model) { SalesEngine::Model.new({}) }

  it "should use today's date for created_at if it isn't passed in" do
    model.created_at.should == Date.today
  end
end
