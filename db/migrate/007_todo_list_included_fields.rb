class TodoListIncludedFields < ActiveRecord::Migration[4.2]
  def change
    add_column :issue_todo_lists, :included_fields, :text
  end
end
