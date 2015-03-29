Redmine::Plugin.register :issue_todo_lists do
  name 'Issue To-do Lists Plugin'
  author 'Den'
  description 'Organize issues in to-do lists by manually ordering their priority'
  version '1.0.1'
  url 'https://github.com/Canidas/issue_todo_lists'
  author_url 'http://den.cx'

  project_module :issue_todo_lists do
    permission :add_issue_todo_lists, {:issue_todo_lists => [:new, :create]}
    permission :view_issue_todo_lists, {:issue_todo_lists => [:index, :show]}
    permission :edit_issue_todo_lists, {:issue_todo_lists => [:update, :edit]}
    permission :delete_issue_todo_lists, {:issue_todo_lists => [:destroy]}
    permission :add_issue_todo_list_items, {:issue_todo_list_items => [:create]}
    permission :order_issue_todo_list_items, {:issue_todo_lists => [:update_item_order]}
    permission :remove_issue_todo_list_items, {:issue_todo_list_items => [:destroy]}
  end

  menu :project_menu, :issue_todo_lists, { :controller => 'issue_todo_lists', :action => 'index' }, :caption => :issue_todo_lists_title, :param => :project_id, :after => :activity
end
