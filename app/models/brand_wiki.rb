class BrandWiki < ActiveRecord::Base
  attr_accessible :brand_id, :version_comment, :bio, :url, :updated_by, :editor_id
  
  acts_as_revisable do
    revision_class_name "BrandWikiRevision"
  end
  
  belongs_to :brand
  belongs_to :editor, :class_name => 'User'
  
  
  validates_length_of :bio, :minimum => 5
  validates_presence_of :editor_id
  
  def differences_between(v1, v2)
    v1model = self.find_revision(v1) || self
    v2model = self.find_revision(v2) || self
    rtn = {'version' => [v1model.revision_number, v2model.revision_number]}
    if v1model.revision_number != v2model.revision_number
      rtn.merge!(v1model.diffs(v2))
    end
    rtn
  end
  
  # convenience getter
  
  def version
    revision_number
  end
  
  # returns history
  def history
    if revisions.count == 0 # This is the first version
      return nil
    end
    
    current_version = [{:version => self.version, :editor => self.editor, :updated_at => self.updated_at, :version_comment => self.version_comment}]
    rtn =
      revisions.map do |ver|
        {:version => ver.revision_number, :editor => ver.editor, :updated_at => ver.updated_at, :version_comment => ver.version_comment}
      end
    return current_version + rtn
  end
end
