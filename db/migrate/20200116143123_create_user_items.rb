class CreateUserItems < ActiveRecord::Migration[5.2]
  def change
    create_table :user_items do |t|
      t.references :image_item, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
