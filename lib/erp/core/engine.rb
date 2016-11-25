module Erp
  module Core
    class Engine < ::Rails::Engine
      isolate_namespace Erp
      
      initializer :append_migrations do |app|
        unless app.root.to_s.match(root.to_s)
          config.paths["db/migrate"].expanded.each do |p|
          app.config.paths["db/migrate"] << p
        end
        end
      end
      
      initializer "static assets" do |app|
        app.middleware.use ::ActionDispatch::Static, "#{root}/public"
      end
      
      # Add a load path for this specific Engine
      config.autoload_paths << File.expand_path("#{root}/lib/erp", __FILE__)
    end
  end
end
