class RemoveClosedIssues < ActiveRecord::Migration[4.2]
  def change
    add_column :issue_todo_lists, :remove_closed_issues, :boolean, :default => false, :null => false
  end
end
