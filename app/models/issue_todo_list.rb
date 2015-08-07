class IssueTodoList < ActiveRecord::Base
  belongs_to :project
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by'
  belongs_to :last_updated_by, :class_name => 'User', :foreign_key => 'last_updated_by'

  # Rails 3 (Redmine 2) and Rails 4 (Redmine 3)
  if Gem::Version.new(Rails::VERSION::STRING) >= Gem::Version.new('4.0.0')
    has_many :issue_todo_list_items, -> { order('position ASC') }, dependent: :destroy
  else
    has_many :issue_todo_list_items, dependent: :destroy, :order => 'position ASC'
  end

  has_many :issues, through: :issue_todo_list_items

  validates :title, presence: true
  before_save :force_updated

  def get_max_position
    max = IssueTodoListItem.where(issue_todo_list_id: self.id).maximum('position')
    max = 0 if max.nil?
    max + 1
  end

  def force_updated
    self.last_updated = current_time_from_proper_timezone
    self.last_updated_by = User.current
  end
end
