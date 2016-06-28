class AddSlugToAdvertisers < ActiveRecord::Migration
  def change
    add_column :advertisers, :slug, :string
  end
end
