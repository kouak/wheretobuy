module BrandWikisHelper
  
  include HTMLDiff
  
  def format_diff(v1, v2)
    diff(v1, v2)
  end
end
