class BrandWiki < ActiveRecord::Base
  attr_accessible :brand_id, :version_comment, :bio, :url, :updated_by, :editor_id
  
  versioned # vestal_versions
  
  belongs_to :brand
  belongs_to :editor, :class_name => 'User'
  
  validates_format_of :url, :with => URI::regexp(%w(http)), :allow_blank => true
  
  def differences_between(v1, v2)
    changes_between(v1, v2)
  end
  
end
