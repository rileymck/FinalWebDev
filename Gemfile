source "https://rubygems.org"

ruby "3.2.5"

# Core framework
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# Asset management with Sprockets
gem "sprockets-rails"

# Database for Active Record
gem "sqlite3", "~> 1.4"

# Server
gem "puma", ">= 5.0"

# JavaScript management with ESM import maps
gem "importmap-rails"

# SPA-like page accelerator and JavaScript framework with Hotwire
gem "turbo-rails"
gem "stimulus-rails"

# JSON builder for APIs
gem "jbuilder"

# Caching
gem "bootsnap", require: false

# Handling image processing and file uploads
gem "image_processing", "~> 1.2"

# User authentication framework
gem "devise"

group :development, :test do
  gem "rspec-rails", "~> 6.0"  # Testing framework
  gem "capybara"               # System testing tool
  gem "selenium-webdriver"     # Web driver for system testing
end

group :development do
  gem "web-console"  # Debugging tool in development
end

# Windows-specific dependencies
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
