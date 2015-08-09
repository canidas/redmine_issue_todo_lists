class ProjectIdentifierToId < ActiveRecord::Migration
  def up
    add_column :issue_todo_lists, :project_id, :integer, null: false, after: :id

    # project_identifier => project_id
    execute <<-SQL
        UPDATE
	          #{IssueTodoList.table_name} issue_todo_lists LEFT JOIN
	          #{Project.table_name} projects ON
		            projects.identifier = issue_todo_lists.project_identifier
        SET
	          issue_todo_lists.project_id = projects.id
    SQL

    remove_column :issue_todo_lists, :project_identifier
  end

  def down
    add_column :issue_todo_lists, :project_identifier, :string, null: false, after: :id

    # project_id => project_identifier
    execute <<-SQL
        UPDATE
	          #{IssueTodoList.table_name} issue_todo_lists LEFT JOIN
	          #{Project.table_name} projects ON
		            projects.id = issue_todo_lists.project_id
        SET
	          issue_todo_lists.project_identifier = projects.identifier
    SQL

    remove_column :issue_todo_lists, :project_id
  end
end
