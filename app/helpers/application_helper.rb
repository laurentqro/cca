module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def component(component_name, locals = {}, &block)
    name = component_name.split("_").first
    render("components/#{name}/#{component_name}", locals, &block)
  end
end
