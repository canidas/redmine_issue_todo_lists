class CreateTodoLists < ActiveRecord::Migration[4.2]
  def up
    create_table :issue_todo_lists do |t|
      t.string :project_identifier
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

  def down
    drop_table :issue_todo_lists
    drop_table :issue_todo_list_items
  end
end
