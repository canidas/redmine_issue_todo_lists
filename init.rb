require 'redmine'

Redmine::Plugin.register :redmine_issue_todo_lists do
  name 'Issue To-do Lists Plugin'
  author 'Den'
  description 'Organize issues in to-do lists by manually ordering their priority'
  version '1.3.3'
  url 'https://github.com/canidas/redmine_issue_todo_lists'
  author_url 'mailto:dev@den.cx'

  project_module :issue_todo_lists do
    permission :add_issue_todo_lists, {:issue_todo_lists => [:new, :create]}
    permission :view_issue_todo_lists, {:issue_todo_lists => [:index, :show]}
    permission :edit_issue_todo_lists, {:issue_todo_lists => [:update, :edit]}
    permission :delete_issue_todo_lists, {:issue_todo_lists => [:destroy]}
    permission :add_issue_todo_list_items, {:issue_todo_list_items => [:create]}
    permission :order_issue_todo_list_items, {:issue_todo_lists => [:update_item_order]}
    permission :remove_issue_todo_list_items, {:issue_todo_list_items => [:destroy]}
    permission :update_issue_todo_list_items, {:issue_todo_list_items => [:update, :show, :edit]}
    permission :add_issue_todo_list_items_context_menu, {:issue_todo_lists => [:bulk_allocate_issues]}
  end

  menu :project_menu, :issue_todo_lists, { :controller => 'issue_todo_lists', :action => 'index' }, :caption => :issue_todo_lists_title, :param => :project_id, :after => :activity

  require File.dirname(__FILE__) + '/lib/redmine_issue_todo_lists/hooks'
  require File.dirname(__FILE__) + '/lib/redmine_issue_todo_lists/issue_patch'
  require File.dirname(__FILE__) + '/lib/redmine_issue_todo_lists/project_patch'
  require File.dirname(__FILE__) + '/lib/redmine_issue_todo_lists/issue_query_patch'

  if Rails.configuration.respond_to?(:autoloader) && Rails.configuration.autoloader == :zeitwerk
    Rails.autoloaders.each { |loader| loader.ignore(File.dirname(__FILE__) + '/lib/redmine_issue_todo_lists') }
  end

  if Rails.version > '6.0' && Rails.autoloaders.zeitwerk_enabled?
    Project.send(:include, RedmineIssueTodoLists::ProjectPatch)
    Issue.send(:include, RedmineIssueTodoLists::IssuePatch)
    unless IssueQuery.included_modules.include?(IssueTodoListsIssueQueryPatch)
      IssueQuery.send(:prepend, IssueTodoListsIssueQueryPatch::InstanceMethods)
    end
  else
    Rails.configuration.to_prepare do
      Project.send(:include, RedmineIssueTodoLists::ProjectPatch)
      Issue.send(:include, RedmineIssueTodoLists::IssuePatch)
      unless IssueQuery.included_modules.include?(IssueTodoListsIssueQueryPatch)
        IssueQuery.send(:prepend, IssueTodoListsIssueQueryPatch::InstanceMethods)
      end
    end
  end
end
