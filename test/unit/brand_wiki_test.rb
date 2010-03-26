require 'test_helper'

class BrandWikiTest < ActiveSupport::TestCase
  
  def test_should_be_valid
    f = Factory.build(:brand_wiki, :brand => Factory.create(:brand), :editor => Factory.create(:user))
    assert f.valid?
  end
  
  def test_bio_validation
    f = Factory.build(:brand_wiki, :bio => nil, :editor => Factory.create(:user))
    assert !f.valid?
  end
  
  def test_editor_id_validation
    f = Factory.build(:brand_wiki, :editor => nil)
    assert !f.valid?
  end
  
  def test_versioned
    set_editors
    f = Factory.create(:brand_wiki, :editor => @editor1) # This is the creation of the profile
    assert_equal 1, f.version
  end
  
  def test_revision_saved_and_valid
    set_editors
    f = Factory.create(:brand_wiki, :editor => @editor1) # first version
    assert f.save!
    
    increment_brand_wiki_versions!(f, +3)
    
    assert_equal 4, f.version
  end
  
  def test_revert_to
    set_editors
    f = Factory.create(:brand_wiki, :editor => @editor1)
    increment_brand_wiki_versions!(f, +3)
    f.revert_to(2)
    assert_equal 2, f.version
  end
  
  def test_last_version
    set_editors
    f = Factory.create(:brand_wiki, :editor => @editor1)
    increment_brand_wiki_versions!(f, +5)
    assert_equal 6, f.send('last_version')
  end
  
  def test_full_history
    set_editors
    f = Factory.create(:brand_wiki, :editor => @editor1)
    increment_brand_wiki_versions!(f, 3)
    assert_equal 4, f.full_history.count
    f.revert_to(2)
    assert_equal 4, f.full_history.count
  end
  
  def test_history
    set_editors
    f = Factory.create(:brand_wiki, :editor => @editor1)
    increment_brand_wiki_versions!(f, 5)
    f.revert_to(2)
    assert_equal 2, f.history.count
  end
  
  def test_differences_between
    set_editors
    f = Factory.create(:brand_wiki, :editor => @editor1, :version_comment => 'v1', :bio => 'This is it !')
    e = {'version' => [1, 1]}
    assert_equal e, f.differences_between(1, 1)
    
    f.update_attributes!(:editor => @editor1, :version_comment => 'v2')
    
    e = {'version' => [1, 2], 'version_comment' => ['v1', 'v2']}
    assert_equal e, f.differences_between(1, 2)
    assert_equal e.merge(e){|k, v| v.reverse}, f.differences_between(2,1)
    
    
    f.update_attributes!(:editor => @editor2, :bio => 'blabla')
    e.merge!({'version' => [1, 3], 'bio' => ['This is it !', 'blabla']})
    assert_equal e, f.differences_between(1, 3)
    
  end
  
  
  private
  
  def increment_brand_wiki_versions!(brand_wiki, versions)
    editor =  @editor1 || Factory.create(:user)
    brand_wiki ||= Factory.create(:brand_wiki, :editor => editor)
    for i in (brand_wiki.version.to_i)..versions
      brand_wiki.update_attributes!(:bio => brand_wiki.bio + "\r\n Version #{i}", :editor => editor, :version_comment => "Version #{i}")
    end
    brand_wiki
  end
  
  def set_editors
    @editor1 = Factory.create(:user)
    @editor2 = Factory.create(:other_user)
  end
end
