module Erp
  class Ability
    include CanCan::Ability
    def initialize(user)
      Dir.glob(Rails.root.join('engines').to_s + "/*") do |d|
        eg = d.split(/[\/\\]/).last
        method = eg + '_ability'
        send(method, user) if self.respond_to?(method.to_sym)
      end
    end
  end
end