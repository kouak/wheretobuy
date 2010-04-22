class BrandWiki < ActiveRecord::Base
  attr_accessible :brand_id, :version_comment, :bio, :url, :editor_id, :time_of_revision, :editor, :brand
  attr_accessor :time_of_revision
  
  belongs_to :brand
  belongs_to :editor, :class_name => 'User'
  
  acts_as_versioned
  
  validates_length_of :bio, :minimum => 5
  validates_presence_of :editor_id
  
  after_save do |brand_wiki| # Activity logging
    a = Activity.edited_brand_wiki(brand_wiki)
    raise Exceptions::ActivityError unless a.save
    true
  end
  
  def differences_between(v1, v2)
    v1model = self.find_version(v1) || self
    v2model = self.find_version(v2) || self
    rtn = {'version' => [v1model.version, v2model.version]}
    if v1model.version != v2model.version
      %w(bio version_comment).each do |c|
        rtn.merge!({c => [v1model[c], v2model[c]]}) unless v1model[c] == v2model[c]
      end
    end
    rtn
  end
  
  
  # returns history
  def history
    self.versions.all.reverse
  end
  
  def find_version(v)
    case v
    when Symbol
      if v == :first
        v = 1
      else
        v = self.version
      end
    end
    self.versions.find(:first, :conditions => {:version => v})
  end
end

BrandWiki.versioned_class.class_eval do 
  belongs_to :editor, :class_name => "User"
end
