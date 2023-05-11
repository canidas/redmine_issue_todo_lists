class IssueTodoListItemsController < ApplicationController

  before_action :find_project
  before_action :find_todo_list

  def create
    @item = IssueTodoListItem.new
    @item.issue_todo_list = @todo_list
    @item.position = @todo_list.get_max_position
    @item.comment = params[:item][:comment]

    match = params[:item][:issue_id].to_s.strip.match(/^#?(\d+)$/)
    if match and match[1]
      @item.issue = Issue.visible.find_by_id(match[1].to_i)
    end

    if not params[:item][:issue_id].empty? and @item.issue.nil?
        @item.errors.add(:base, l(:error_issue_not_found_in_project))
    elsif @item.issue.nil?
      @item.errors.add(:base, l(:issue_todo_lists_item_create_empty))
    else
      @item.save
    end

    respond_to do |format|
      format.js {
        @todo_list_items = @todo_list.issue_todo_list_items
        @issue_query = IssueQuery.new
      }
    end
  end

  def edit
    respond_to do |format|
      format.js {
        @issue_query = IssueQuery.new
        @item = IssueTodoListItem.find(params[:id])
        render :edit
      }
    end
  end

  def show
    @item = IssueTodoListItem.find(params[:id])

    respond_to do |format|
      format.json { render json: @item }
    end
  end

  def destroy
    @item = IssueTodoListItem.find(params[:id])
    @item.destroy
    find_todo_list # Refresh last updated box

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {
        @todo_list_items = @todo_list.issue_todo_list_items
        @issue_query = IssueQuery.new
        render :create
      }
    end
  end

  def update
    @item = IssueTodoListItem.find(params[:id])
    @item.comment = params[:item][:comment]
    data = []
    if params[:item][:data]
      params[:item][:data].each do |dataItem|
        data.push({field: dataItem[:field].to_s, value: dataItem[:value].to_s})
      end
    end
    @item.data = data
    @item.save
    find_todo_list # Refresh last updated box

    # render :plain => @item.inspect
    # render :plain => params.inspect
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