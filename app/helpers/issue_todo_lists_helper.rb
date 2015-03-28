module IssueTodoListsHelper
  include SortHelper
  include QueriesHelper
  include CustomFieldsHelper # for plugin extended_fields

  def get_route_for_localize
    if ['new', 'create'].include? params[:action]
      return 'new'
    elsif ['edit', 'update'].include? params[:action]
      return 'edit'
    end
    params[:action]
  end
end
