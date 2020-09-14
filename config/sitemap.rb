# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://#{ENV['FDQN']}"
SitemapGenerator::Sitemap.compress = false

SitemapGenerator::Sitemap.create do
  add new_user_session_path
  add new_user_registration_path
  add terms_and_conditions_path
  add how_to_path
end
