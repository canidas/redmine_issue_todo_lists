class TodoListItemData < ActiveRecord::Migration[4.2]
  def change
    add_column :issue_todo_list_items, :data, :text
  end
end
