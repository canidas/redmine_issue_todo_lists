module IssueTodoListsHelper
  include SortHelper
  include QueriesHelper

  # Prevent render error for column_content()
  if Redmine::Plugin.installed?(:redmine_blocked_reason)
    include IssuesBlockedReasonHelper
  end

  def get_route_for_localize
    if ['new', 'create'].include? params[:action]
      return 'new'
    elsif ['edit', 'update'].include? params[:action]
      return 'edit'
    end
    params[:action]
  end

  def self.has_todo_lists_permission?(projects)
    projects.each do |project|
      return true if User.current.allowed_to?(:view_issue_todo_lists, project)
    end
    false
  end

  def self.get_all_todo_lists_from_project_issues(issues)
    todo_lists = Set.new
    issues.each do |issue|
      # Get to-do lists of project and all parent projects
      projects = issue.project.self_and_ancestors
      projects.each do |sub_project|
        sub_project.issue_todo_lists.each do |todo_list|
          todo_lists.add(todo_list)
        end
      end
    end

    # If only one issue is selected: Add all allocated to-do lists anyway
    if issues.count == 1
      issues[0].issue_todo_lists.each do |todo_list|
        todo_lists.add(todo_list)
      end
    end

    todo_lists.keep_if { |todo_list| User.current.allowed_to?(:add_issue_todo_list_items_context_menu, todo_list.project) }
    todo_lists.to_a.sort! { |a,b| a.title <=> b.title }
  end

  def todo_list_items_to_csv(todo_list, issue_query)
    encoding = 'UTF-8'
    bom = "\uFEFF" # Byte Order Mark (BOM)
    export = FCSV.generate(:col_sep => l(:general_csv_separator)) do |csv|
      if todo_list.included_columns.count > 0
        issue_columns = issue_query.available_columns.select {|column| todo_list.included_columns.include?(column.name.to_s)}
      else
        issue_columns = issue_query.available_columns.select {|column| issue_query.columns.include?(column)}
      end

      issue_columns.unshift(
        QueryColumn.new(:position,
                        :caption => :issue_todo_label_order)
      )
      issue_columns.push(
        QueryColumn.new(:comments,
                        :caption => :field_comments)
      )

      csv << issue_columns.map { |c| c.caption.to_s }

      issue_columns = issue_columns.drop(1)
      issue_columns.pop
      todo_list.issue_todo_list_items.each_with_index do |item, itemIdx|
        fields = []
        fields.push(item.position)
        issue_columns.each do |column|
          fields.push(csv_content(column, item.issue))
        end
        fields.push(item.comment)
        csv << fields.collect { |c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }
      end
    end
    bom + export
  end
end
