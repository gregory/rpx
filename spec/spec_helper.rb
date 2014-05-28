require 'bundler/setup'
Bundler.setup(:default, :development)

require_relative '../lib/rpx'
$LOAD_PATH <<  File.dirname(__FILE__)
