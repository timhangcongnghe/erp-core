# The BootstrapBreadcrumbsBuilder is a Bootstrap compatible breadcrumb builder.
# It provides basic functionalities to render a breadcrumb navigation according to Bootstrap's conventions.
#
# BootstrapBreadcrumbsBuilder accepts a limited set of options:
# * separator: what should be displayed as a separator between elements
#
# You can use it with the :builder option on render_breadcrumbs:
#     <%= render_breadcrumbs :builder => ::BootstrapBreadcrumbsBuilder, :separator => "&raquo;" %>
#
# Note: You may need to adjust the autoload_paths in your config/application.rb file for rails to load this class:
#     config.autoload_paths += Dir["#{config.root}/lib/"]
#
module Erp
  class BootstrapBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
    def render
      @context.content_tag(:ul, class: 'page-breadcrumb') do
        @elements.collect do |element|
          render_element(element)
        end.join.html_safe
      end
    end
  
    def render_element(element)
      current = @context.current_page?(compute_path(element))
  
      @context.content_tag(:li, :class => ('active' if current)) do
        if current
          link_or_text = @context.content_tag(:span, compute_name(element))
        else
          link_or_text = @context.link_to_unless_current(compute_name(element), compute_path(element), element.options)
        end
        divider = @options[:separator].html_safe || @context.content_tag(:span, ('/').html_safe, :class => 'divider') unless current
  
        link_or_text + (divider || '')
      end
    end
  end
end