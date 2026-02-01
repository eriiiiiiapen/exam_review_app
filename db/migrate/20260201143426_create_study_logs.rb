class CreateStudyLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :study_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true
      t.integer :understanding_level, null: false, default: 0
      t.date :study_on
      t.text :note

      t.timestamps
    end

    add_index :study_logs, [:user_id, :topic_id]
  end
end
