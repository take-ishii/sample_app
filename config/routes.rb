Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'         # 新しいセッションのページ（ログイン） "/login"へアクセスされた際に"session#new"アクションを実行
  post   '/login',   to: 'sessions#create'      # 新しいセッションの作成（ログイン） "session#create"アクションの情報を"/login"へ送信
  delete '/logout',  to: 'sessions#destroy'     # セッションの削除（ログアウト）
  resources :users
end