class AddHappiesCountToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :happies_count, :integer, default: 0
  end
end
