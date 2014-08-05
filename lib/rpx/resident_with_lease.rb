module Rpx
  class ResidentWithLease < Resident
    VALID_EVENTS = ['moveout', 'movein']

    property :residentid
    property :namesalutation
    property :middlename
    property :namegeneration

    property :residentagestatus

    property :email, from: :emailaddress
    property :leases, from: :leaseslist, with: ->(v) { v[:leases] }
    coerce_key :leases, Rpx::Lease

    def self.where(options, client=Client.new(options))
      resident_hashs = client.api_call :residentsearchbyinfo, options do |xml|
        xml.tem :residentsearch do |xml|
          xml.tem :extensionData
          client.add_attributes_if_present(xml, options, ResidentWithLease.properties.to_a)

          if options[:leaselist]
            xml.tem :leaselist do |xml|
              xml.tem :leases do |xml|
                client.add_attributes_if_present(xml, options, options.fetch(:leaselist).keys)
              end
            end
          end
        end
      end

      site_properties = {siteid: options.fetch(:siteid), pmcid: options.fetch(:pmcid)}
      [resident_hashs].flatten.map{ |resident_hash| ResidentWithLease.new(resident_hash.merge(site_properties))  }
    end


    def current_resident?
      current_lease.leasestatus == "Current Resident"
    end

    def moved_out?
      current_lease.moved_out?
    end

    def self.find(options, client=Client.new(options))
      resident_hash = client.api_call :getresidentbyresidentid, options do |xml|
        xml.tem :residentid, options.fetch(:resident_id)
      end

      site_properties = {siteid: options.fetch(:siteid), pmcid: options.fetch(:pmcid)}
      new(resident_hash.merge(site_properties))
    end

    def self.with_events(options, client=Client.new(options))
      events = [*options.fetch(:events)]
      raise InvalidArgument.new(":events must be included in #{VALID_EVENTS.join(', ')}") unless !events.blank? && events.all?{|event| VALID_EVENTS.include? event}

      resident_hashs = client.api_call :residentsearchbydate, options do |xml|
        xml.tem :residentsearch do |xml|
          xml.tem :extensionData
          xml.tem :startdate, options.fetch(:startdate) #start date to retrieve active residents
          xml.tem :enddate, options.fetch(:enddate) #end date to retrieve active residents
          xml.tem :events do |xml|
            events.each{|event| xml.tem :string, event}
          end
          client.add_attributes_if_present(xml, options, :headofhousehold)
        end
      end
      site_properties = {siteid: options.fetch(:siteid), pmcid: options.fetch(:pmcid)}
      [resident_hashs].flatten.map{ |resident_hash| new(resident_hash.merge(site_properties)) }
    end

    def fullname
      "#{namesalutation} #{firstname} #{middlename} #{lastname} #{namegeneration}".strip
    end

    def residenttype
      residentagestatus
    end
  end
end
