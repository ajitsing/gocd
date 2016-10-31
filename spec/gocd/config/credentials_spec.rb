require './lib/gocd/config/credentials'

RSpec.describe GOCD::Credentials, 'credentials' do

  it '#curl_credentials should return credentials' do
    credentials = GOCD::Credentials.new 'admin', 'password'
    expect(credentials.curl_credentials).to eq 'admin:password'
  end
end