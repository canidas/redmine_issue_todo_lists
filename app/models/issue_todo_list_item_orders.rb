class IssueTodoListItemOrders
  attr_reader :issue_todo_list_item

  def initialize(issue_todo_list_item)
    @issue_todo_list_item = issue_todo_list_item
  end

  def positions
    issue_todo_list_item.pluck(:position).join(', ')
  end

  def sortable_value
    issue_todo_list_item.first.issue_todo_list.id
  end

  def visible?(user = User.current)
    user.allowed_to?(:view_issue_todo_lists, @project, global: true)
  end
end