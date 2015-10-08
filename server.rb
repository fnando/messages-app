require "bundler/setup"
require "sinatra"

helpers do
  def send_image(locals)
    content_type "image/svg+xml"
    erb :image, {}, locals
  end

  def h(html)
    CGI::escapeHTML(html.to_s)
  end

  def message
    h(params[:message])
  end

  def partial(name, locals = {})
    name = name.gsub(/(\/)?([^\/]+)\z/, "\\1_\\2")
    erb :"#{name}", {}, locals
  end
end

get "/success.svg" do
  send_image(type: "check", stroke: "#B5CFB5", fill: "#DFF0D8", text: "#326B31", icon: "#417505")
end

get "/info.svg" do
  send_image(type: "info", stroke: "#B5CAE5", fill: "#E0E9F4", text: "#3060A3", icon: "#3060A3")
end

get "/warning.svg" do
  send_image(type: "warning", stroke: "#E8D7B1", fill: "#FCF8E3", text: "#8D6A32", icon: "#8D6A32")
end

get "/error.svg" do
  send_image(type: "error", stroke: "#E9B4B4", fill: "#F5DEDE", text: "#A93538", icon: "#A93538")
end
