class BrandWikiRevision < ActiveRecord::Base
  acts_as_revision :revisable_class_name => "BrandWiki"
  
  belongs_to :brand
  belongs_to :editor, :class_name => 'User'
  
end