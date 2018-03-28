require './lib/gocd/config/credentials'

RSpec.describe GOCD::Credentials, 'credentials' do

  it '#curl_credentials should return credentials' do
    credentials = GOCD::Credentials.new 'admin', 'password'
    expect(credentials.curl_credentials).to eq 'admin:password'
  end

  it '#curl_credentials should be escaped for the command line' do
    credentials = GOCD::Credentials.new('admin', '"cpF@<`89Q.[cA]C%hj>M<s3\'sl')
    expect(credentials.curl_credentials).to eq('admin:\"cpF@\<\`89Q.\[cA\]C\%hj\>M\<s3\\\'sl')
  end
end
