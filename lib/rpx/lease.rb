module Rpx
  class Lease < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    include Hashie::Extensions::Coercion
    #coerce_value Date, LeaseDate #transform all the dates to LeaseDate format

    property :leaseid

    property :unitid
    property :unitnumber
    property :buildingid
    property :buildingnumber

    property :datebegin
    property :dateend
    property :moveindate
    property :moveoutdate

    def self.coerce(list_of_hash)
      return self.coerce([list_of_hash]) unless list_of_hash.is_a?(Array)

      list_of_hash.map{ |h| self.new(h) }
    end
  end
end
