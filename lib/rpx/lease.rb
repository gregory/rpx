module Rpx
  class Lease < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    include Hashie::Extensions::Coercion

    property :leaseid

    property :leasestatus
    property :residentrelationship

    property :datesigned
    property :datebegin
    property :dateend
    property :moveindate
    property :moveoutdate

    property :noticegivendate
    property :noticefordate

    property :unitid
    property :unitnumber
    property :buildingid
    property :buildingnumber

    property :renewaloffersavailable
    property :acceptpayments
    property :acceptcheck

    property :aspets
    property :inevict
    property :incollection
    property :guarantorbit
    property :signerbit
    property :hohbit
    property :activebit

    def self.coerce(list_of_hash)
      return self.coerce([list_of_hash]) unless list_of_hash.is_a?(Array)

      list_of_hash.map{ |h| self.new(h) }
    end
  end
end
