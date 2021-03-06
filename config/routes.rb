Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: 'devise/invitations'}
  root to: "home#index"
  resources :users, only: [:show, :index, :destroy]
  resources :groups do
    resources :bills
  end
  get 'group_bills_ajax/:id', to: 'groups#bills', as: 'group_bills_ajax'
  resources :group_users, path: :users, module: :groups
  get 'users/:id/ban', to: 'users#ban', as: 'ban'
  put 'settle_debt/:debt_id', to: 'users#settle_debt', as: 'settle_debt'
end
