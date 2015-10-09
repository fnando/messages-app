require "bundler/setup"
require "sinatra"
require "dotenv"
require "sucker_punch"
require "aitch"
require "tilt/erb"

Dotenv.load(".env")

require_relative "./lib/google_analytics"

use Rack::Session::Cookie,
  key: "_hellobits_messages",
  secret: ENV.fetch("SESSION_SECRET")

use Rack::Head

helpers do
  def send_image(locals)
    headers["Cache-Control"] = "public, max-age=31536000, must-revalidate"
    headers["ETag"] = Digest::SHA1.hexdigest(request.fullpath)
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

before do
  session[:cid] ||= SecureRandom.hex(10)
end

get "/" do
  GoogleAnalytics.page_view("/", request, session[:cid])
  erb :index
end

get "/success.svg" do
  GoogleAnalytics.page_view("/success.svg", request, session[:cid]) unless params[:skip]
  send_image(type: "check", stroke: "#B5CFB5", fill: "#DFF0D8", text: "#326B31", icon: "#417505")
end

get "/info.svg" do
  GoogleAnalytics.page_view("/info.svg", request, session[:cid]) unless params[:skip]
  send_image(type: "info", stroke: "#B5CAE5", fill: "#E0E9F4", text: "#3060A3", icon: "#3060A3")
end

get "/warning.svg" do
  GoogleAnalytics.page_view("/warning.svg", request, session[:cid]) unless params[:skip]
  send_image(type: "warning", stroke: "#E8D7B1", fill: "#FCF8E3", text: "#8D6A32", icon: "#8D6A32")
end

get "/error.svg" do
  GoogleAnalytics.page_view("/error.svg", request, session[:cid]) unless params[:skip]
  send_image(type: "error", stroke: "#E9B4B4", fill: "#F5DEDE", text: "#A93538", icon: "#A93538")
end
