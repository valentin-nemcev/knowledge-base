Rails.application.routes.draw do

  root to: redirect('/articles')

  resources :articles, except: :create do
    resources :reviews, only: [:create, :destroy]
    member do
      post 'restore'
      patch 'autosave', action: :update_autosave
      match via: [:patch, :put],
        constraints: lambda { |req| req.params.key?(:autosave) },
        action: :update_autosave
    end
  end

end
