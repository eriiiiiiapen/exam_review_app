class CreateSubjects < ActiveRecord::Migration[8.1]
  def change
    create_table :subjects do |t|
      t.references :exam, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
