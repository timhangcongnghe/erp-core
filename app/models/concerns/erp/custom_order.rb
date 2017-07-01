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
      query = self.class
      query = query.where(parent_id: self.parent_id) if self.class.column_names.include?("parent_id")
      query = query.where(property_group_id: self.property_group_id) if self.class.column_names.include?("property_group_id")
      query = query.where(category_id: self.category_id) if self.class.column_names.include?("category_id")
      query.where('custom_order < ?', self.custom_order).order('custom_order desc').first
    end

    # get next item
    def next
      query = self.class
      query = query.where(parent_id: self.parent_id) if self.class.column_names.include?("parent_id")
      query = query.where(property_group_id: self.property_group_id) if self.class.column_names.include?("property_group_id")
      query = query.where(category_id: self.category_id) if self.class.column_names.include?("category_id")
      query.where('custom_order > ?', self.custom_order).order('custom_order asc').first
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
      def reset_custom_order
        self.order("created_at").each_with_index do |item,index|
          item.update_column(:custom_order, index)
        end
      end
    end
  end
end
