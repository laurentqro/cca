Rails.application.config.content_security_policy do |p|
  # allow everything from the current hostname by default (only secured)
  p.default_src :self, :https
  # allow loading fonts and images from data-uri
  p.font_src    :self, :https, :data
  # don't forget to add your cloud hostname for ActiveStorage assets
  p.img_src     :self, :https, :data, "cloudfront.example.com"
  # disallow <object> tags (Good-bye Flash!)
  p.object_src  :none
  # allow inline <style> (remove :unsafe_inline if you don't want it)
  p.style_src   :self, :https, :unsafe_inline
  # allow webpack-dev-server host as allowed origin for connect-src
  p.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
end
