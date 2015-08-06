module RedmineIssueTodoLists
  class Hooks < Redmine::Hook::ViewListener
    def view_issues_context_menu_end(context={})
      # Collect all to-do lists of all projects
      context[:todo_lists] = IssueTodoListsHelper.get_all_todo_lists_from_project_issues(context[:issues])

      context[:controller].send(:render_to_string, {
        :partial => 'issue_todo_lists/issues_context_menu',
        :locals => context
      })
    end
  end
end