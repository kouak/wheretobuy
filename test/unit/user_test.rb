require 'test_helper'

class UserTest < ActiveSupport::TestCase
  subject { Factory(:user) }
  
  should_validate_uniqueness_of :username, :email
  should_allow_values_for :email, "test@example.com"
  should_not_allow_values_for :email, "test"
  should_validate_date_of :birthday
  
  should_ensure_length_in_range :username, 2..30
  
  should_have_many :comments
  
  context "updating email or password" do
    setup {
      @user = Factory.create(:user, :password => '123456', :password_confirmation => '123456')
    }
    
    should "not perform with no current_password set" do
      @user.update_attributes(:email => 'a@a.com')
      assert_equal false, @user.errors.on(:current_password).empty?
    end
    
    should "not perform with a wrong current_password provided" do
      @user.update_attributes(:password => '654321', :current_password => 'wrong')
      assert_equal false, @user.errors.on(:current_password).empty?
    end
    
    should "perform given a correct current_password" do
      @user.update_attributes(:email => 'a@a.com', :current_password => '123456')
      assert @user.errors.on(:current_password).nil?
    end
    
    should "perform with skip_current_password_check set to true" do
      @user.skip_current_password_validation = true
      @user.update_attributes(:email => 'a@a.com')
      assert @user.errors.on(:current_password).nil?
    end
  end
  
  context "test age" do
    setup {
      birthday = "1973-04-17"
      @user = Factory.build(:user, :birthday => birthday)
    }
    
    # Birthday is 'today'.
    should "equals 34 on birthday" do
      assert_equal 34, @user.age("2007-04-17")
    end
    
    # Birthday has already happenned this year 
    should "equals 34 after birthday" do
      %w(2007-04-18 2007-05-01 2007-12-10).each do |date|
        assert_equal 34, @user.age(date)
      end
    end
    
    # Birthday has not happened this year.
    should "equals 33 before birthday" do
      %w(2007-01-20 2007-04-01 2007-04-16).each do |date|
        assert_equal 33, @user.age(date)
      end
    end
  end
  
  context "is votable" do
    setup {
      @voter = Factory.create(:user)
      @votable = Factory.create(:brand)
    }
    context "vote_for" do
      setup {
        @voter.vote_for(@votable)
      }
      should_change("voted_on? returns value", :from => false, :to => true) { @voter.voted_on?(@votable) }
      should_change("votable.votes count", :from => 0, :to => 1) { @votable.votes.count }
      should_create(:vote)
    end
    context "with existant vote" do
      setup {
        @voter.vote_against(@votable)
      }
      context "vote_for" do
        setup { @voter.vote_for(@votable) }
      
        should_not_change("voted_on? returns value") { @voter.voted_on?(@votable) }
        should_not_change("votable.votes count") { @votable.votes.count }
        should_not_change("vote.count"){ Vote.count }
      end
    end
  end
end
