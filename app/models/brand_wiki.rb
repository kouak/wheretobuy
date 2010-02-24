class BrandWiki < ActiveRecord::Base
  attr_accessible :brand_id, :version_comment, :bio, :url, :updated_by, :editor_id
  
  versioned # vestal_versions
  
  belongs_to :brand
  belongs_to :editor, :class_name => 'User'
  
  validates_format_of :url, :with => URI::regexp(%w(http)), :allow_blank => true
  
  def differences_between(v1, v2)
    changes_between(v1, v2)
  end
  
  # returns full version history
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
