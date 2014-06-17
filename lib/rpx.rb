require 'savon'
require 'hashie'

module Rpx
  autoload :Client, 'rpx/client'
  autoload :Configuration, 'rpx/configuration'
  autoload :Resident, 'rpx/resident'
  autoload :ResidentWithLease, 'rpx/resident_with_lease'
  autoload :Lease, 'rpx/lease'

  extend self

  attr_accessor :config

  def configure
    @config = Configuration.new.tap{ |configuration| yield(configuration) }
  end
end
