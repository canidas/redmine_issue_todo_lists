class IssueTodoListItemsController < ApplicationController

  before_filter :find_project
  before_filter :find_todo_list

  def create
    @item = IssueTodoListItem.new
    @item.issue_todo_list = @todo_list
    @item.position = @todo_list.get_max_position

    match = params[:item][:issue_id].to_s.strip.match(/^#?(\d+)$/)
    if match
      @item.issue = Issue.visible.find_by_id(match[1].to_i)
      @item.save
    end

    respond_to do |format|
      format.js {
        @todo_list_items = @todo_list.issue_todo_list_items
        @issue_query = IssueQuery.new
      }
    end
  end

  def destroy
    @item = IssueTodoListItem.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.js {
        @todo_list_items = @todo_list.issue_todo_list_items
        @issue_query = IssueQuery.new
        render :create
      }
    end
  end

  private
  def find_project
    @project = Project.find(params[:project_id])
    authorize
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_todo_list
    @todo_list = IssueTodoList.find(params[:issue_todo_list_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end