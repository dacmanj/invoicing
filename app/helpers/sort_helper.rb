# app/helpers/sort_helper.rb
module SortHelper
  def toggle_sort_caret_link(sort,default,params,sort_params)
      dir_toggle = {"ASC" => "DESC", "DESC" => "ASC","" => nil}
      selected = (params[:sort] == sort) #currently selected
      if !selected
          dir = default
      else
          dir = dir_toggle[params[:dir].to_s] || default
      end

      sort_caret_link(sort,dir,sort_params,selected)
  end
  def sort_caret_link(sort,dir,sort_params, selected = false)
      if selected
          chevron = {"ASC" => "chevron-down", "DESC" => "chevron-up", "" => "chevron-down"}[dir]
          style = ""
      else
          chevron = {"ASC" => "chevron-up", "DESC" => "chevron-down", "" => "chevron-down"}[dir]
          style = "color: #ccc"
      end
      link_to glyph(chevron), invoices_path(sort_params.merge(:sort => sort, :dir => dir)), :style => style, :class => "noprint"
  end
end

