Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'         # 新しいセッションのページ（ログイン） "/login"へアクセスされた際に"session#new"アクションを実行
  post   '/login',   to: 'sessions#create'      # 新しいセッションの作成（ログイン） "session#create"アクションの情報を"/login"へ送信
  delete '/logout',  to: 'sessions#destroy'     # セッションの削除（ログアウト）

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :users
  resources :account_activations, only: [:edit] # アカウント有効化に使うリソース (editアクション) を追加する
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  
  namespace :api, format: 'json' do
    namespace :v1 do
      resources :users do
        scope module: :users do
          resources :microposts,  only: [:index]
          resources :relationships, only: [:create]
        end
      end
    end
  end
end
