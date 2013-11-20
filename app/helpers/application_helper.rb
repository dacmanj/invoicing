module ApplicationHelper
  def flash_class(level)
    case level
    when :notice then "info"
    when :success then "info"
    when :error then "error"
    when :alert then "warning"
    end
  end

  def logo
    image_tag("logo.png", :width => "50px", :height => "50px", :alt => "PFLAG Logo", :class => "round")
  end
end
