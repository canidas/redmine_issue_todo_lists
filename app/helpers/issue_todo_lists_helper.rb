module IssueTodoListsHelper
  include SortHelper
  include QueriesHelper
  include CustomFieldsHelper # for plugin extended_fields

  def get_route_for_localize
    if ['new', 'create'].include? params[:action]
      return 'new'
    elsif ['edit', 'update'].include? params[:action]
      return 'edit'
    end
    params[:action]
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
end
