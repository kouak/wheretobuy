class BrandWiki < ActiveRecord::Base
  attr_accessible :brand_id, :version_comment, :bio, :url, :updated_by
  
  versioned # vestal_versions
  
  belongs_to :brand
  
  
end
