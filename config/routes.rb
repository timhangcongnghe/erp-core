Erp::Core::Engine.routes.draw do
  devise_for :users, class_name: "Erp::User", module: :devise
	namespace :backend do
		root to: "dashboard#index"
	end
end
