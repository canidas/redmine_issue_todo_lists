# :as is needed as polymorphic_url fails without it
scope '/projects/:project_id', :as => 'project' do
  resources :issue_todo_lists do
    post :update_item_order, on: :member
    post :bulk_allocate_issues, on: :member
    resources :items, controller: 'issue_todo_list_items', only: [:create, :destroy]
  end
end