require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Votes.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Votes.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Votes.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to votes_url(assigns(:votes))
  end
  
  def test_edit
    get :edit, :id => Votes.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Votes.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Votes.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Votes.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Votes.first
    assert_redirected_to votes_url(assigns(:votes))
  end
  
  def test_destroy
    votes = Votes.first
    delete :destroy, :id => votes
    assert_redirected_to votes_url
    assert !Votes.exists?(votes.id)
  end
end
