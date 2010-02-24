require 'test_helper'

class BrandWikisControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => BrandWiki.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    BrandWiki.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    BrandWiki.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to brand_wiki_url(assigns(:brand_wiki))
  end
  
  def test_edit
    get :edit, :id => BrandWiki.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    BrandWiki.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BrandWiki.first
    assert_template 'edit'
  end
  
  def test_update_valid
    BrandWiki.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BrandWiki.first
    assert_redirected_to brand_wiki_url(assigns(:brand_wiki))
  end
  
  def test_destroy
    brand_wiki = BrandWiki.first
    delete :destroy, :id => brand_wiki
    assert_redirected_to brand_wikis_url
    assert !BrandWiki.exists?(brand_wiki.id)
  end
end
