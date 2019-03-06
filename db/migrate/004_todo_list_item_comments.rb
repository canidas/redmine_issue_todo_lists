class TodoListItemComments < ActiveRecord::Migration
  def change
    add_column :issue_todo_list_items, :comment, :text, :after => :issue_id
  end
end
