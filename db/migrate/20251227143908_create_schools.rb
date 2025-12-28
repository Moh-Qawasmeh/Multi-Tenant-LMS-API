class CreateSchools < ActiveRecord::Migration[7.1]
  def change
    create_table :schools do |t|
      t.string :name
      t.string :subdomain
      t.boolean :active

      t.timestamps
    end
  end
end
