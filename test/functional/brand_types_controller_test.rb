require 'test_helper'

class BrandTypesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => BrandTypes.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    BrandTypes.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    BrandTypes.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to brand_types_url(assigns(:brand_types))
  end
  
  def test_edit
    get :edit, :id => BrandTypes.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    BrandTypes.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BrandTypes.first
    assert_template 'edit'
  end
  
  def test_update_valid
    BrandTypes.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BrandTypes.first
    assert_redirected_to brand_types_url(assigns(:brand_types))
  end
  
  def test_destroy
    brand_types = BrandTypes.first
    delete :destroy, :id => brand_types
    assert_redirected_to brand_types_url
    assert !BrandTypes.exists?(brand_types.id)
  end
end
