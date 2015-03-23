class IssueTodoListsController < ApplicationController

  before_filter :find_project
  before_filter :find_todo_list, :only => [:show, :edit, :update, :destroy, :update_item_order]

  def index
    @todo_lists = IssueTodoList.where(project_identifier: @project.identifier).order('id')
  end

  def new
    @todo_list = IssueTodoList.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @todo_list = IssueTodoList.new(params[:issue_todo_list])
    @todo_list.project_identifier = @project.identifier
    @todo_list.created_by = User.current
    if @todo_list.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:issue_todo_lists_new_success)
          redirect_to project_issue_todo_list_path(@project, @todo_list)
        }
      end
    else
      respond_to do |format|
        format.html { render 'form' }
      end
    end
  end

  def show
    @todo_list_items = @todo_list.issue_todo_list_items
    @issue_query = IssueQuery.new
  end

  def edit
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def update
    respond_to do |format|
      if @todo_list.update_attributes(params[:issue_todo_list])
        format.html { redirect_to project_issue_todo_list_path(@project, @todo_list), notice: l(:issue_todo_lists_edit_success) }
      else
        format.html { render 'form' }
      end
    end
  end

  def destroy
    @todo_list.destroy

    respond_to do |format|
      format.html { redirect_to :action => :index, notice: l(:issue_todo_lists_destroy_success) }
    end
  end

  def update_item_order
    items = params[:item]
    items ||= []

    items.each_with_index { |item_id, index|
      item = IssueTodoListItem.find(item_id)
      item.position = index + 1
      item.save
    }

    respond_to do |format|
      format.js {
        # Refresh last_updated-info in instance
        @todo_list = find_todo_list
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
    @todo_list = IssueTodoList.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
