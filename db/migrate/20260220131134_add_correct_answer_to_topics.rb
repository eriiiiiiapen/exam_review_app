class AddCorrectAnswerToTopics < ActiveRecord::Migration[8.1]
  def change
    add_column :topics, :correct_answer, :text
  end
end
