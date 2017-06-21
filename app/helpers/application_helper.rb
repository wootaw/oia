module ApplicationHelper

  def webpack_javascript_include_tag(name)
    full_name = "#{name}_bundle.js"
    src = asset_url("/assets/#{full_name}")
    if Rails.env.development?
      src = "http://localhost:8080/assets/#{full_name}"
    elsif Rails.configuration.webpack[:manifest]
      asset_name = Rails.configuration.webpack[:manifest]["#{name}.js"]
      if asset_name
        gzs = "#{asset_name}.gz"
        asset_name = gzs if File.exists?("#{Rails.root}/public/assets/#{gzs}")
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

  def markdown(text)
    return nil if text.blank?
    # Rails.cache.fetch(['markdown', Digest::MD5.hexdigest(text)]) do
      sanitize_markdown(Apiwoods::Markdown.call(text))
    # end
  end
  
  def sanitize_markdown(html)
    raw Sanitize.fragment(html, Apiwoods::Sanitize::DEFAULT)
  end

  def method_color(m)
    {
      'GET'    => 'label-success', 
      'POST'   => 'label-warning', 
      'PUT'    => 'label-primary', 
      'DELETE' => 'label-danger' 
    }[m.to_s]
  end

  def location_color(l)
    {
      'header'  => 'text-muted',
      'path'    => 'text-danger',
      'query'   => 'text-info-dker',
      'form'    => 'text-warning',
      'body'    => 'text-info',
      'cookie'  => '',
    }[l]
  end

  def colour_path(path, parameters)
    ps = parameters.select { |e| e.path? }.map(&:name)
    rs = path
    ps.each { |e| rs = rs.gsub(Regexp.new("(:#{e})"), '<span class="text-danger">\1</span>') }
    rs
  end
end
