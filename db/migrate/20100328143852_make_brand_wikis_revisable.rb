class MakeBrandWikisRevisable < ActiveRecord::Migration
  def self.up
        add_column :brand_wikis, :revisable_original_id, :integer
        add_column :brand_wikis, :revisable_branched_from_id, :integer
        add_column :brand_wikis, :revisable_number, :integer, :default => 0
        add_column :brand_wikis, :revisable_name, :string
        add_column :brand_wikis, :revisable_type, :string
        add_column :brand_wikis, :revisable_current_at, :datetime
        add_column :brand_wikis, :revisable_revised_at, :datetime
        add_column :brand_wikis, :revisable_deleted_at, :datetime
        add_column :brand_wikis, :revisable_is_current, :boolean, :default => true
      end

  def self.down
        remove_column :brand_wikis, :revisable_original_id
        remove_column :brand_wikis, :revisable_branched_from_id
        remove_column :brand_wikis, :revisable_number
        remove_column :brand_wikis, :revisable_name
        remove_column :brand_wikis, :revisable_type
        remove_column :brand_wikis, :revisable_current_at
        remove_column :brand_wikis, :revisable_revised_at
        remove_column :brand_wikis, :revisable_deleted_at
        remove_column :brand_wikis, :revisable_is_current
      end
end
