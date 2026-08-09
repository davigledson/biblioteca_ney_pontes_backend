module ApplicationHelper
  def frontend_url
    ENV.fetch("FRONTEND_URL", "http://localhost:3010")
  end
end