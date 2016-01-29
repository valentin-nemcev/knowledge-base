Rails.application.routes.draw do

  root to: redirect('/articles')

  resources :articles, except: :create do
    member do
      post 'mark_as_reviewed'
      patch 'autosave', action: :update_autosave
      match via: [:patch, :put],
        constraints: lambda { |req| req.params.key?(:autosave) },
        action: :update_autosave
    end
  end

end
