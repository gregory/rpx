# Rpx

Ruby Client to talk with the RealPage Exchange SOAP API

## Installation

Add this line to your application's Gemfile:

    gem 'rpx'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rpx

## Usage

	Rpx.configure do |config|
		config.api_url     = API_URL
		config.licensekey = KEY
    	config.username    = USERNAME
      	config.password    = PASSWORD
	end

	payload={
		fromdate: '2014-05-10',
		todate: '2014-06-10',
		events: ['moveout']
	}
	residents = Rpx::Client.search_by_date(payload) #You'll have residents with their leases
	residents.count => 10
	resident = residents.first

	resident.firstname
	resident.email
	resident.leases.count => 3
	lease = resident.leases.last

	lease.unitid
	etc (check the code, it's pretty straight forward!)

## Contributing

1. Fork it ( http://github.com/gregory/rpx/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
