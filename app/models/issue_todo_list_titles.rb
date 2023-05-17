class IssueTodoListTitles
  attr_reader :issue_todo_lists

  def initialize(issue_todo_lists)
    @issue_todo_lists = issue_todo_lists
  end

  def titles
    issue_todo_lists.pluck(:title).join(', ')
  end

  def sortable_value
    issue_todo_lists.first.id
  end

  def visible?(user = User.current)
    user.allowed_to?(:view_issue_todo_lists, @project, global: true)
  end
end