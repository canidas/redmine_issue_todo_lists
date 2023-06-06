module RedmineIssueTodoLists
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do

        after_save :remove_todo_list_allocations
        has_many :issue_todo_list_items, dependent: :destroy
        has_many :issue_todo_lists, through: :issue_todo_list_items
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def remove_todo_list_allocations
        if self.status.is_closed and self.status != self.status_was
          self.issue_todo_list_items.each do |item|
            if item.issue_todo_list.remove_closed_issues
              item.destroy
            end
          end
        end
      end

      def todolists_with_positions
        todolists = IssueTodoList.joins(:issue_todo_list_items).where(issue_todo_list_items: { issue_id: id })
        todolists.map do |todolist|
          {
            id: todolist.id,
            project_id: todolist.project_id,
            title: todolist.title,
            description: todolist.description,
            last_updated: todolist.last_updated,
            remove_closed_issues: todolist.remove_closed_issues,
            position: todolist.issue_todo_list_items.find_by(issue_id: id).position
          }
        end
      end
    end
  end
end
