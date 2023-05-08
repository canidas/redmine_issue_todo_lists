class TodoListIncludedColumns < ActiveRecord::Migration[4.2]
  def change
    add_column :issue_todo_lists, :included_columns, :text
  end
end
