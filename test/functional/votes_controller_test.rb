require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  
  context "as an anonymous user" do
    %w[vote_for vote_against vote_nil].each do |action|
      context "request #{action}" do
        setup {
          get action, :brand_id => 'invalid'
        }
        should_be_denied
      end
    end
  end
  
  context "as a logged in user" do
    setup {
      login_as :active_user
    }
    context "with an invalid votable" do
      setup {
        Brand.expects(:find).with('invalid').raises(ActiveRecord::RecordNotFound)
      }
      %w[vote_for vote_against vote_nil].each do |action|
        context "request #{action}" do
          setup {
            get action, :brand_id => 'invalid'
          }
          should_respond_with 404
          should_not_set_the_flash
        end
      end
    end
    
    context "with a valid votable" do
      setup {
        @votable ||= Factory.stub(:brand)
        Brand.expects(:find).with('valid').returns(@votable)
      }
      
      %w[vote_for vote_against vote_nil].each do |action|
        context "post #{action}" do
          setup {
            current_user.expects(action.to_sym).with(@votable).returns(true)
            post action.to_sym, :brand_id => 'valid'
          }
          should_set_the_flash_to(/vote/i)
          should_redirect_to('the votable page'){ brand_path(@votable) }
        end
        
        context "xhr post #{action}" do
          setup {
            current_user.expects(action.to_sym).with(@votable).returns(true)
            post action.to_sym, :format => 'json', :brand_id => 'valid'
          }
          should_respond_with :success
        end
      end
    end
    
  end
  
end