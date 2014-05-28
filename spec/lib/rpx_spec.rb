require 'spec_helper'

describe Rpx do
  subject{ described_class }

  describe '.configure' do
    let(:api_url){"foo_url"}
    let(:license_key){"foo_license"}
    let(:username){"foo_username"}
    let(:password){"foo_password"}

    before do
      subject.configure do |config|
        config.api_url = api_url
        config.license_key = license_key
        config.username = username
        config.password = password
      end
    end

    it "has the credential parameters" do
      subject.config.api_url.should eq api_url
      subject.config.api_url.should eq  api_url
      subject.config.license_key.should eq  license_key
      subject.config.username.should eq  username
      subject.config.password.should eq  password
    end
  end
end
