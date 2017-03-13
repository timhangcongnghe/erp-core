Erp::Core::Engine.routes.draw do
	scope "(:locale)", locale: /en|vi/ do
		devise_for :users,
			class_name: "Erp::User",
			module: :devise,
			:controllers => {
				:sessions => "erp/users/sessions"
			}
		
		namespace :backend do
			get '/' => 'dashboard#index'
			resources :users do
				collection do
					post 'list'
					get 'dataselect'
					delete 'delete_all'
					put 'activate'
					put 'deactivate'
					put 'activate_all'
					put 'deactivate_all'
				end
			end
			post '/editor/upload' => 'editor_uploads#upload'
		end
		
		get 'login', to: 'erp/users/sessions#new', as: :login
	end
end
