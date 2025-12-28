class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.references :school, null: false, foreign_key: true
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
