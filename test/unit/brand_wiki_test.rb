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
    assert_equal 0, f.revision_number
  end
  
  def test_revision_saved_and_valid
    set_editors
    f = Factory.create(:brand_wiki, :editor => @editor1) # first version
    assert f.save! # version 0
    
    increment_brand_wiki_versions!(f, +3)
    
    assert_equal 3, f.revision_number
    
    assert_equal 'Version 3', f.version_comment
  end
  
  def test_history
    set_editors
    f = Factory.create(:brand_wiki, :editor => @editor1, :version_comment => 'Version 0')
    increment_brand_wiki_versions!(f, +3)
    sleep(2)
    t = Time.now
    
    assert_equal 4, f.history.count # current version + ancestors
    
    ver = f.history.first
    
    assert_equal @editor1, ver[:editor]
    assert_equal 2, (t - ver[:updated_at]).round # there should be 2 seconds between now and the revision
    
    expected = 0..4.map {|i| "Version #{i}"}
    
    assert_equal expected.reverse, f.history.map {|v| v[:version_comment]}
    
  end
  
  def test_differences_between
    set_editors
    f = Factory.create(:brand_wiki, :editor => @editor1, :version_comment => 'v0', :bio => 'This is it !')
    e = {'version' => [0, 0]}
    assert_equal e, f.differences_between(0, 0)
    
    f.update_attributes!(:version_comment => 'v1')
    
    e = {'version' => [0, 1], 'version_comment' => ['v0', 'v1']}
    assert_equal e, f.differences_between(0, 1)
    assert_equal e.merge(e){|k, v| v.reverse}, f.differences_between(1,0)
    
    
    f.update_attributes!(:editor => @editor2, :bio => 'blabla')
    e.merge!({'version' => [0, 2], 'bio' => ['This is it !', 'blabla']})
    assert_equal e, f.differences_between(0, 2)
    
  end
  
  
  private
  
  def increment_brand_wiki_versions!(brand_wiki, versions)
    editor =  @editor1 || Factory.create(:user)
    brand_wiki ||= Factory.create(:brand_wiki, :editor => editor)
    for i in (brand_wiki.revision_number.to_i + 1)..(brand_wiki.revision_number.to_i + versions)
      brand_wiki.update_attributes!(:bio => brand_wiki.bio + "\r\n Version #{i}", :editor => editor, :version_comment => "Version #{i}")
    end
    brand_wiki
  end
  
  def set_editors
    @editor1 = Factory.create(:user)
    @editor2 = Factory.create(:other_user)
  end
end
