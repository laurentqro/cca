module DefaultUrlOptions
  def default_url_options
    {
      :host => ENV["HOST"],
      :from => ENV["SYSTEM_FROM_EMAIL"],
    }
  end
end
