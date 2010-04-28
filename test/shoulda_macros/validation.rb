class Test::Unit::TestCase
  def self.should_validate_date_of(*attributes)
    klass = @model_class
    attributes.each do |attribute|
      attribute = attribute.to_sym
      should_not_allow_values_for attribute, "99/21/1985", "1/1/2090", "bla"
      should_allow_values_for attribute, "20-09-1985", "2009/08/15", ""
    end
  end
end
