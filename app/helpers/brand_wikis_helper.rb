module BrandWikisHelper
  require 'differ'
  def diff(v1, v2)
    Differ.format = :html
    Differ.diff_by_word(v1, v2)
  end
end
