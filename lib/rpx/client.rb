module Rpx
  class Client
    NAMESPACES = {
      "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
      "xmlns:tem"=>"http://tempuri.org/"
    }

    def initialize(options={})
      @read_timeout = options.delete(:read_timeout){ Rpx.config.read_timeout || 120 }
      @debug = options.delete(:debug){false}
    end

    def add_attributes_if_present(xml, options, attributes)
      return add_attributes_if_present(xml, options, [attributes]) unless attributes.is_a? Array

      attributes.each{ |attribute|  xml.tem(attribute, options[attribute]) if options[attribute] }
    end

    def api_call(action_name, options)
      raw_response = client.request action_name do
        soap.xml do |xml|
          xml.soapenv :Envelope, NAMESPACES do |xml|
            xml.soapenv :Header
            xml.soapenv :Body do |xml|
              xml.tem action_name do |xml|
                xml.tem :auth do |xml|
                  xml.tem :siteid, options.fetch(:siteid)
                  xml.tem :pmcid, options.fetch(:pmcid)
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

      resident_list_from_raw({ action_name: action_name, raw_response: raw_response })
    end

    private

    def client
      @client ||= Savon::Client.new(log: @debug, pretty_print_xml: true) do
        wsdl.document = Rpx.config.api_url
        http.read_timeout = @read_timeout
      end
    end

    def resident_list_from_raw(params)
      action_name  = params.fetch(:action_name)
      raw_response = params.fetch(:raw_response)

      raw_response[:"#{action_name}_response"][:"#{action_name}_result"][:residentlist][:resident]
    end
  end
end
