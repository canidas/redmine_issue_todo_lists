class TodoListItemComments < ActiveRecord::Migration[4.2]
  def change
    add_column :issue_todo_list_items, :comment, :text, :after => :issue_id
  end
end
