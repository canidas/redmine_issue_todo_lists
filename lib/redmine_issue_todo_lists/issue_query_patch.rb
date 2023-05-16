require_dependency 'issue_query'
module RedmineIssueTodoLists
  module IssueQueryPatch
    module InstanceMethods
      def initialize_available_filters
        super
        if User.current.admin? || User.current.allowed_to?(:view_issue_todo_lists, project)
          add_available_filter("todo_lists_ids", :type => :list_optional, values: issue_todo_lists_values, :label => :issue_todo_lists_title)
        end
      end

      def available_columns
        return @available_columns if @available_columns

        @available_columns = super
        if User.current.allowed_to?(:view_issue_todo_lists, project)
          @available_columns << QueryAssociationColumn.new(:issue_todo_list_titles, :titles, caption: :issue_todo_lists_title)
        end

        @available_columns
      end

      def issue_todo_lists_values
        return [] unless project
        IssueTodoList.where(project_id: project.self_and_ancestors.ids + project.self_and_descendants).order('project_id', 'title').map { |s| [s.project.name.to_s + ': ' + s.title.to_s, s.id.to_s] }
      end

      def sql_for_todo_lists_ids_field(field, operator, value)
        # accepts a comma separated list of ids
        case operator
        when "="
          issue_ids = IssueTodoListItem.where(:issue_todo_list_id => value.map(&:to_i)).pluck(:issue_id)
          if issue_ids.present?
            "#{Issue.table_name}.id IN (#{issue_ids.join(",")})"
          else
            "1=0"
          end
        when "!"
          issue_ids = IssueTodoListItem.where(:issue_todo_list_id => value.map(&:to_i)).pluck(:issue_id)
          if issue_ids.present?
            "#{Issue.table_name}.id NOT IN (#{issue_ids.join(",")})"
          else
            "1=1"
          end
        when "!*"
          issue_ids = IssueTodoListItem.all.pluck(:issue_id)
          if issue_ids.present?
            "#{Issue.table_name}.id NOT IN (#{issue_ids.join(",")})"
          else
            "1=1"
          end
        when "*"
          issue_ids = IssueTodoListItem.all.pluck(:issue_id)
          if issue_ids.present?
            "#{Issue.table_name}.id IN (#{issue_ids.join(",")})"
          else
            "1=0"
          end
        end
      end

    end
  end
end

class Issue < ActiveRecord::Base
  def issue_todo_list_titles
    issue_todo_lists = IssueTodoList.joins(:issue_todo_list_items).where(issue_todo_list_items: { issue_id: id })
    IssueTodoListTitles.new(issue_todo_lists)
  end
end
