class ActionController::TestCase
  def self.should_render_form_for(record)
    should("render a form for #{record}") do
      assert_select "form" do
        assert_select "input[name*=#{record}]"
      end
    end
  end
end