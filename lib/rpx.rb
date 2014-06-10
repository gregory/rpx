require 'savon'
require 'hashie'
Dir[File.dirname(__FILE__) + '/rpx/**/*.rb'].each{ |file| require file }

module Rpx
  extend self

  attr_accessor :config

  def configure
    @config = Configuration.new.tap{ |configuration| yield(configuration) }
  end
end
