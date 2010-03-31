require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Friendship.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Friendship.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Friendship.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to friendship_url(assigns(:friendship))
  end
  
  def test_edit
    get :edit, :id => Friendship.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Friendship.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Friendship.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Friendship.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Friendship.first
    assert_redirected_to friendship_url(assigns(:friendship))
  end
  
  def test_destroy
    friendship = Friendship.first
    delete :destroy, :id => friendship
    assert_redirected_to friendships_url
    assert !Friendship.exists?(friendship.id)
  end
end
