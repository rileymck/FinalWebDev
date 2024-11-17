class DropWhalesTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :whales, if_exists: true
  end
end
