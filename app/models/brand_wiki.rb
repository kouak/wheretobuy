class BrandWiki < ActiveRecord::Base
  attr_accessible :brand_id, :version_comment, :bio, :url, :updated_by, :editor_id
  
  versioned # vestal_versions
  
  belongs_to :brand
  belongs_to :editor, :class_name => 'User'
  
  
  validates_length_of :bio, :minimum => 5
  validates_presence_of :editor_id
  
  def differences_between(v1, v2)
    v1 = versions.number_at(v1) || 1
    v2 = versions.number_at(v2) || 1
    rtn = {'version' => [v1, v2]}
    if v1 != v2
      rtn.merge!(changes_between(v1, v2))
    end
    rtn
  end
  
  # returns full version history regardless of current version
  def full_history
    current_version = version # Save current version
    revert_to(:last) # Go back to the latest
    rtn = history # Pull history
    revert_to(current_version) # and go back to initial state
    rtn
  end
  
  # returns history before current version
  def history
    if versions.size == 0 # This is the first version
      return nil
    end
    current_version = [{:version => self.version, :editor => self.editor, :updated_at => self.updated_at, :version_comment => self.version_comment}]
    versions.with_scope(:find => {:conditions => ['number < ?', version]}) do
      rtn =
        versions.map do |ver|
          {:version => ver.number - 1, :editor => ver.user, :updated_at => ver.updated_at, :version_comment => 'caca'}
        end
      return current_version + rtn
    end
  end
end
