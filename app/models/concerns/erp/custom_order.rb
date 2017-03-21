module Erp
  module CustomOrder
    extend ActiveSupport::Concern
    
    included do
      after_create :init_custom_order
    end
    
    def init_custom_order
      self.update_column(:custom_order, self.class.maximum("custom_order").to_i + 1)
    end
    
    # get prev item
    def prev
      self.class.where(parent_id: self.parent_id).where('custom_order < ?', self.custom_order).first
    end
    
    # get next item
    def next
      self.class.where(parent_id: self.parent_id).where('custom_order > ?', self.custom_order).first
    end
    
    # move up item
    def move_up
      prev_item = self.prev
      if prev_item.present?
        current_order = self.custom_order
        self.update_column(:custom_order, prev_item.custom_order)
        prev_item.update_column(:custom_order, current_order)
      end
    end
    
    # move down item
    def move_down
      next_item = self.next
      if next_item.present?
        current_order = self.custom_order
        self.update_column(:custom_order, next_item.custom_order)
        next_item.update_column(:custom_order, current_order)
      end
    end
    
    module ClassMethods
      def self.reset_custom_order
        self.order("created_at").each_with_index do |item,index|
          item.update_column(:custom_order, index)
        end
      end
    end
  end
end