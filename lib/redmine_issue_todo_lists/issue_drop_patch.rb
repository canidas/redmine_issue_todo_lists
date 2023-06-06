module RedmineIssueTodoLists
  module IssueDropPatch
    def self.included(base)
      base.class_eval do
        base.send(:include, InstanceMethods)
      end
    end
    module InstanceMethods
      def todolists_with_positions
        todolists = @issue.todolists_with_positions
        RedmineIssueTodoLists::Liquid::TodoListsDrop.new(todolists)
      end
    end
  end
end

if defined?(RedmineCrm::Liquid::IssueDrop)
  unless RedmineCrm::Liquid::IssueDrop.included_modules.include?(RedmineIssueTodoLists::IssueDropPatch)
    RedmineCrm::Liquid::IssueDrop.send(:include, RedmineIssueTodoLists::IssueDropPatch)
  end
end