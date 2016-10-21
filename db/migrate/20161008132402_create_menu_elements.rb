class CreateMenuElements < ActiveRecord::Migration
  def change
    create_table :menu_elements do |t|
      t.string :title
      t.text :href
      t.belongs_to :page, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
