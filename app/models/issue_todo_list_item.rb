class IssueTodoListItem < ActiveRecord::Base
  belongs_to :issue_todo_list
  belongs_to :issue

  validates_presence_of :issue_todo_list, :issue, :allow_nil => true
  validates_uniqueness_of :issue_id, :scope => :issue_todo_list_id, :allow_nil => true

  before_save :force_updated
  before_destroy :force_updated

  serialize :data, Array

  def force_updated
    todo_list = self.issue_todo_list
    todo_list.force_updated
    todo_list.save
  end
  def visible?(user = User.current)
    user.allowed_to?(:view_issue_todo_lists, @project, global: true)
  end
end
