class IssueTodoListsController < ApplicationController

  before_action :find_project, :except => [:bulk_allocate_issues]
  before_action :find_todo_list, :only => [:show, :edit, :update, :destroy, :update_item_order, :bulk_allocate_issues]

  accept_api_auth :index, :show

  include IssueTodoListsHelper

  def index
    @todo_lists = IssueTodoList.where(project_id: @project.id).order('id')
    respond_to do |format|
      format.api
      format.html { render action: 'index', layout: false if request.xhr? }
    end
  end

  def new
    @todo_list = IssueTodoList.new
    @issue_query = IssueQuery.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def create
    @todo_list = IssueTodoList.new(issue_todo_list_params)
    @todo_list.project_id = @project.id
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
    respond_to do |format|
      format.api
      format.html { render action: 'show', layout: false if request.xhr? }
      format.csv  { send_data(todo_list_items_to_csv(@todo_list, @issue_query), :type => 'text/csv; header=present', :filename => 'issue_todo_list_items.csv') }
    end
  end

  def edit
    @issue_query = IssueQuery.new
    respond_to do |format|
      format.html { render 'form' }
    end
  end

  def update
    respond_to do |format|
      if @todo_list.update_attributes(issue_todo_list_params)
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

  def bulk_allocate_issues
    params[:issue_ids].each do |issue_id|
      issue = Issue.find(issue_id)
      found_list = false
      # Is issue already allocated to selected to-do list?
      issue.issue_todo_lists.each do |todo_list|
        if todo_list == @todo_list
          found_list = todo_list
          break
        end
      end
      if found_list
        # Delete item if only all issues are to be deleted and issue is allocated to to-do list
        if params[:issue_ids].count == -(params[:list_count].to_i)
          found_list.issue_todo_list_items.each do |item|
            if item.issue == issue
              item.destroy
            end
          end
        end
      else
        # Allocate issue to to-do list
        item = IssueTodoListItem.new
        item.issue_todo_list = @todo_list
        item.position = @todo_list.get_max_position
        item.issue = issue
        item.save
      end
    end

    redirect_to params[:back_url]
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

  def issue_todo_list_params
    if Gem::Version.new(Rails::VERSION::STRING) >= Gem::Version.new('4.0.0')
      params[:issue_todo_list][:included_columns] ||= []
      params[:issue_todo_list][:included_fields] ||= []
      params.require(:issue_todo_list).permit(:title, :description, :remove_closed_issues, :included_columns => [], :included_fields => [])
    else
      params[:issue_todo_list]
    end
  end
end
