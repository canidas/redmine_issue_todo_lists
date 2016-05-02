require 'redmine'
require_dependency 'redmine_issue_todo_lists/hooks'

Redmine::Plugin.register :redmine_issue_todo_lists do
  name 'Issue To-do Lists Plugin'
  author 'Den'
  description 'Organize issues in to-do lists by manually ordering their priority'
  version '1.1.2'
  url 'https://github.com/canidas/redmine_issue_todo_lists'
  author_url 'http://den.cx'

  project_module :issue_todo_lists do
    permission :add_issue_todo_lists, {:issue_todo_lists => [:new, :create]}
    permission :view_issue_todo_lists, {:issue_todo_lists => [:index, :show]}
    permission :edit_issue_todo_lists, {:issue_todo_lists => [:update, :edit]}
    permission :delete_issue_todo_lists, {:issue_todo_lists => [:destroy]}
    permission :add_issue_todo_list_items, {:issue_todo_list_items => [:create]}
    permission :order_issue_todo_list_items, {:issue_todo_lists => [:update_item_order]}
    permission :remove_issue_todo_list_items, {:issue_todo_list_items => [:destroy]}
    permission :add_issue_todo_list_items_context_menu, {:issue_todo_lists => [:bulk_allocate_issues]}
  end

  menu :project_menu, :issue_todo_lists, { :controller => 'issue_todo_lists', :action => 'index' }, :caption => :issue_todo_lists_title, :param => :project_id, :after => :activity

  Rails.configuration.to_prepare do
    unless Project.included_modules.include? RedmineIssueTodoLists::ProjectPatch
      Project.send(:include, RedmineIssueTodoLists::ProjectPatch)
    end

    unless Issue.included_modules.include? RedmineIssueTodoLists::IssuePatch
      Issue.send(:include, RedmineIssueTodoLists::IssuePatch)
    end
  end
end
