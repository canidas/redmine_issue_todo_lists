class ProjectIdentifierToId < ActiveRecord::Migration
  def up
    add_column :issue_todo_lists, :project_id, :integer, null: true, after: :id

    # project_identifier => project_id (as identifier is not unique use LIMIT)
    execute <<-SQL
      UPDATE #{IssueTodoList.table_name} issue_todo_lists SET project_id = (
        SELECT id FROM #{Project.table_name} WHERE identifier = issue_todo_lists.project_identifier LIMIT 1
      )
    SQL

    remove_column :issue_todo_lists, :project_identifier
  end

  def down
    add_column :issue_todo_lists, :project_identifier, :string, null: true, after: :id

    # project_id => project_identifier
    execute <<-SQL
      UPDATE #{IssueTodoList.table_name} issue_todo_lists SET project_identifier = (
        SELECT identifier FROM #{Project.table_name} WHERE id = issue_todo_lists.project_id
      )
    SQL

    remove_column :issue_todo_lists, :project_id
  end
end
