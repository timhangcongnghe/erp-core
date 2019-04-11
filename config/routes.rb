Erp::Core::Engine.routes.draw do
	scope "(:locale)", locale: /en|vi/ do
		devise_for :users,
			class_name: "Erp::User",
			module: :devise,
			:controllers => {
				:sessions => "erp/users/sessions",
				:registrations => "erp/users/registrations",
				:passwords => "erp/users/passwords",
				:confirmations => "erp/users/confirmations",
			}

		get '/auth/:provider/callback', to: 'frontend/users#omniauth_login'

		namespace :backend do
			get '/' => 'dashboard#index'
			resources :users do
				collection do
					post 'list'
					get 'dataselect'
					put 'activate'
					put 'deactivate'
					put 'activate_all'
					put 'deactivate_all'

					post 'save_filter'
				end
			end
			resources :user_groups do
				collection do
					post 'list'
					get 'dataselect'
					put 'activate'
					put 'deactivate'
				end
			end
			resources :accounts do
				collection do
					get 'profile'
					post 'update_contact'
					post 'update_user'
					post 'update_password'
				end
			end
			post '/editor/upload' => 'editor_uploads#upload'
			patch '/editor/upload' => 'editor_uploads#upload'
		end
	end
end
