class RemoveClosedIssues < ActiveRecord::Migration
  def change
    add_column :issue_todo_lists, :remove_closed_issues, :boolean, :default => false, :null => false
  end
end
