module Rpx
  class Resident < Hashie::Trash
    include Hashie::Extensions::IgnoreUndeclared
    include Hashie::Extensions::Coercion

    property :resident_id, from: :residentmemberid
    property :residenthouseholdid
    property :leaseid

    property :unitid
    property :buildingnumber
    property :unitnumber

    property :firstname
    property :lastname
    property :billingname

    property :homephone
    property :workphone
    property :email
    property :faxnumber
    property :cellphone

    property :inevict
    property :nochk
    property :incollection
    property :inpaymentplan
    property :pendingbalance
    property :balance
    property :estfutchgs
    property :curlateamt
    property :leasestatus
    property :leasetype
    property :residenttype, with: ->(value){ value == 'H' ? 'Head of Household' : 'Other'}

    property :siteid
    property :pmcid

    def residenttype
      self[:residenttype] == 'H' ? 'Head of Household' : 'Other'
    end

    def self.where(options, client=Client.new(options))
      resident_hashs = client.api_call :getresidentlist, options do |xml|
        xml.tem :residentsearch do |xml|
          xml.tem :extensionData
          client.add_attributes_if_present(xml, options, Resident.properties.to_a)
        end
      end

      site_properties = {siteid: options.fetch(:siteid), pmcid: options.fetch(:pmcid)}
      [resident_hashs].flatten.map{ |resident_hash| Resident.new(resident_hash.merge(site_properties)) }
    end

    def leases
      @leases ||= ResidentWithLease.find({resident_id: self.resident_id, siteid: siteid, pmcid: pmcid}).leases
    end

    def current_lease
      @current_lease ||= leases.sort_by{ |lease| lease.dateend }.last
    end

    def status
      current_lease.leasestatus
    end

    def moved_out?
      return false if current_resident?

      current_lease.moved_out?
    end

    def minor?
      current_lease.residentrelationship.downcase[/minor/]
    end
    def self.current_residents(options, client=Client.new(options))
      self.where(options, client).select{|resident| resident.current_resident? }
    end

    def current_resident?
      self.leasestatus == "Current"
    end

    def fullname
      "#{firstname} #{lastname}".strip #TODO: ask them to add middleman saluration and generation in the api
    end

    def status
      leasestatus
    end
  end
end
