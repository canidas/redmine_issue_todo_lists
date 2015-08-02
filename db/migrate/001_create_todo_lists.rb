class CreateTodoLists < ActiveRecord::Migration
  def up
    # Check if migration has already been run
    version = ::ActiveRecord::Base.connection.select_values(
        "SELECT version FROM #{::ActiveRecord::Migrator.schema_migrations_table_name} WHERE version='1-issue_todo_lists'"
    )

    # Plugin directory has been renamed
    # Delete entry and return because migration adds entry afterwards anyway
    if version.length != 0
      execute <<-SQL
        DELETE FROM #{::ActiveRecord::Migrator.schema_migrations_table_name} WHERE version = '1-issue_todo_lists';
      SQL

      return
    end

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
