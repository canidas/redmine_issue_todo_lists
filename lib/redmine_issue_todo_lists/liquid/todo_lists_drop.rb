module RedmineIssueTodoLists
  module Liquid
    class TodoListsDrop < ::Liquid::Drop
      def initialize(todolists)
        @todolists = todolists
      end

      def items
        @todolists.map { |todolist| TodoListDrop.new(todolist) }
      end
    end

    class TodoListDrop < ::Liquid::Drop
      def initialize(todolist)
        @todolist = todolist
      end

      def id
        @todolist[:id]
      end

      def project_id
        @todolist[:project_id]
      end

      def title
        @todolist[:title]
      end

      def description
        @todolist[:description]
      end

      def last_updated
        @todolist[:last_updated]
      end

      def remove_closed_issues
        @todolist[:remove_closed_issues]
      end

      def position
        @todolist[:position]
      end
    end
  end
end
