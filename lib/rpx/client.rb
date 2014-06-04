module Rpx
  class Client
    NAMESPACES = {
      "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
      "xmlns:tem"=>"http://tempuri.org/"
    }

    VALID_EVENTS = ['moveout', 'movein']

    attr_accessor :raw_response, :residents

    def initialize(options={})
      @read_timeout = options.fetch(:read_timeout){ Rpx.config.read_timeout || 120 }
      @debug = options.fetch(:debug){false}
    end

    def client
      @client ||= Savon::Client.new(log: @debug, pretty_print_xml: true) do
        wsdl.document = Rpx.config.api_url
        http.read_timeout = @read_timeout
      end
    end

    def self.search_by_date(options)
      events = [*options.fetch(:events)]
      raise InvalidArgument.new(":events must be included in ") unless events.all?{|event| VALID_EVENTS.include? event}

      self.new(options).api_call :residentsearchbydate, options do |xml|
        xml.tem :residentsearch do |xml|
          xml.tem :startdate, options.fetch(:fromdate) #start date to retrieve active residents
          xml.tem :enddate, options.fetch(:todate) #end date to retrieve active residents
          xml.tem :events do |xml|
            events.each{|event| xml.tem :string, event}
          end
        end
      end
    end

    def api_call(action_name, options)
      @raw_response = client.request action_name do
        soap.xml do |xml|
          xml.soapenv :Envelope, NAMESPACES do |xml|
            xml.soapenv :Header
            xml.soapenv :Body do |xml|
              xml.tem action_name do |xml|
                xml.tem :auth do |xml|
                  xml.tem :siteid, options.fetch(:siteid)
                  xml.tem :pmcid, options.fetch(:pmcid)
                  #xml.tem :siteid, '1971375'
                  #xml.tem :pmcid, '1971374'
                  xml.tem :username, Rpx.config.username
                  xml.tem :password, Rpx.config.password
                  xml.tem :licensekey, Rpx.config.licensekey
                end
                yield(xml)
              end
            end
          end
        end
      end

      @residents = resident_list_from_raw({action_name: action_name}).map{ |res_hash| Resident.new(res_hash) }
    end

    private

    def resident_list_from_raw(options)
      action_name = options.fetch(:action_name)
      self.raw_response[:"#{action_name}_response"][:"#{action_name}_result"][:residentlist][:resident]
    end
  end
end
