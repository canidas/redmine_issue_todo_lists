class CreateTodoLists < ActiveRecord::Migration
  def change
    create_table :issue_todo_lists do |t|
      t.integer :project_identifier
      t.string :title
      t.text :description
      t.integer :created_by
      t.datetime :last_updated
      t.integer :last_updated_by
    end

    create_table :issue_todo_list_items do |t|
      t.integer :issue_todo_list_id
      t.integer :issue_id
      t.integer :position
    end
  end
end
