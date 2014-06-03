module Rpx
  class Resident < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    include Hashie::Extensions::Coercion

    property :residentid
    property :residenthouseholdid
    property :firstname
    property :lastname
    property :middlename
    property :email, from: :emailaddress


    property :leases, from: :leaseslist, with: ->(v){ v[:leases] }
    coerce_key :leases, Rpx::Lease
  end
end
