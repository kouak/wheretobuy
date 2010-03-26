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
    if versions.count == 0
      return nil
    end
    rtn = (1..version).to_a.reverse.map do |ver| # for each version
      if ver != version # if current object doesn't match needed version
        revert_to(ver) # revert_to this version
      end
      {:version => ver, :editor => editor, :version_comment => version_comment, :updated_at => updated_at} # find attributes
    end
    reload # cancel revert_to calls
    rtn
  end
end
