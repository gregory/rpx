require 'bundler/setup'
require 'yaml'
require 'pry'
Bundler.setup(:default, :development)

require_relative '../lib/rpx'
$LOAD_PATH <<  File.dirname(__FILE__)
RSpec.configure do |config|
  config.before :suite do
    Rpx.configure do |config|
      configure          = settings["configure"]
      config.api_url     = configure["api_url"]
      config.licensekey = configure["licensekey"]
      config.username    = configure["username"]
      config.password    = configure["password"]
    end
  end

  def settings
    @settings ||= YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'spec.yml'))
  end
end
