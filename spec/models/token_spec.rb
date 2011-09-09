require 'spec_helper'

describe Token do
  
  describe "checkin with token full day and motivation co-working" do
    before do
      @user = Factory(:user)
      full_day = Factory(:token_type, :title => 'full day')
      @co_working_motivation = Factory(:motivation, :title => 'co-working')
      Timecop.freeze(Time.now)  do
        @token = Factory(:token,:token_type=>full_day,:user=>@user,:start_at=>nil,:stop_at=>nil,:motivation=>@co_working_motivation)
      end
    end
    it "be work" do
      @token.start_at.should be_nil
      @token.stop_at.should be_nil
      @token.used.should be_false
      @token.checkin(@co_working_motivation)
      # @token.start_time_of_day.should eql(@token.start_at)
      # @token.stop_time_of_day.should eql(@token.stop_at)
      @token.start_time_of_day.should_not be_nil
      @token.stop_time_of_day.should_not be_nil
      @token.used.should be_true
      @token.motivation.title.should eql(@co_working_motivation.title)
    end
  end
  
  describe "checkin with token full day" do
    before do
      @user = Factory(:user)
      full_day = Factory(:token_type,:title=>'full day')
      @token = Factory(:token,:token_type=>full_day,:user=>@user,:start_at=>nil,:stop_at=>nil)
    end
    it "be work" do
      @token.start_at.should be_nil; @token.stop_at.should be_nil
      @token.used.should be_false
      @token.checkin(@token.motivation)
      @token.start_time_of_day.should eq(@token.start_at)
      @token.stop_time_of_day.should eq(@token.stop_at)
      @token.used.should be_true
    end
  end

  describe "checkin with token half day morning" do
    before do
      @user = Factory(:user)
      full_day = Factory(:token_type,:title=>'half day')
      @token = Factory(:token,:token_type=>full_day,:user=>@user,:start_at=>nil,:stop_at=>nil)
    end
    it "be work" do
      Timecop.freeze(Time.now.change(:hour => 9)) do
        @token.start_at.should be_nil; @token.stop_at.should be_nil
        @token.used.should be_false
        @token.checkin(@token.motivation)
        @token.start_time_of_day.should eq(@token.start_at)
        @token.time_break.should eq(@token.stop_at)
        @token.used.should be_true
      end
    end
  end
  
  describe "checkin with token half day afternoon" do
    before do
      @user = Factory(:user)
      full_day = Factory(:token_type,:title=>'half day')
      @token = Factory(:token,:token_type=>full_day,:user=>@user,:start_at=>nil,:stop_at=>nil)
    end
    it "be work" do
      Timecop.freeze(Time.now.change(:hour => 14)) do
        @token.start_at.should be_nil; @token.stop_at.should be_nil
        @token.used.should be_false
        @token.checkin(@token.motivation)
        @token.start_at.should eql(@token.time_break)
        @token.stop_at.should eql(@token.stop_time_of_day)
        @token.used.should be_true
      end
    end
  end

end
