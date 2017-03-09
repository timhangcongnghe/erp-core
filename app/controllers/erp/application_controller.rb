module Erp
  class ApplicationController < ActionController::Base
		Dir.glob(Rails.root.join('engines').to_s + "/*") do |d|
			eg = d.split(/[\/\\]/).last
			if eg != "core" and Erp::Core.available?(eg)
				helper "Erp::#{eg.camelize}::Engine".constantize.helpers
			end
		end
  end
end
