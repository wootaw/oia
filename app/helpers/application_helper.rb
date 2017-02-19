module ApplicationHelper

  def webpack_javascript_include_tag(name)
    full_name = "#{name}_bundle.js"
    src = asset_url("/assets/#{full_name}")
    if Rails.env.development?
      src = "http://localhost:8080/assets/#{full_name}"
    elsif Rails.configuration.webpack[:manifest]
      asset_name = Rails.configuration.webpack[:manifest]["#{name}.js"]
      if asset_name
        src = asset_url("/assets/#{asset_name}")
      end
    end
    "<script src=\"#{src}\"></script>".html_safe
  end

  def webpack_stylesheet_link_tag(name)
    full_name = "#{name}_bundle.css"
    src = asset_url("/assets/#{full_name}")
    if Rails.env.development?
      src = "http://localhost:8080/assets/#{full_name}"
    elsif Rails.configuration.webpack[:manifest]
      asset_name = Rails.configuration.webpack[:manifest]["#{name}.css"]
      if asset_name
        src = asset_url("/assets/#{asset_name}")
      end
    end
    "<link rel=\"stylesheet\" href=\"#{src}\">".html_safe
  end

end
