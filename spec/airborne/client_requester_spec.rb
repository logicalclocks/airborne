require 'spec_helper'
require 'openssl'

describe 'client requester' do
  before do
    allow(RestClient::Request).to receive(:execute)
    RSpec::Mocks.space.proxy_for(self).remove_stub_if_present(:get)
  end

  after do
    allow(RestClient).to receive(:send).and_call_original
    Airborne.configure { |config| config.headers =  {} }
    Airborne.configure { |config| config.timeout = 123 }
  end

  it 'should set :content_type to :json by default' do
    get '/foo'

    expect(RestClient::Request).to have_received(:execute)
                            .with(:method => :get, :url => 'http://www.example.com/foo', 
                                  :headers => { content_type: :json }, :verify_ssl => OpenSSL::SSL::VERIFY_NONE,
                                  :timeout => 60)
  end

  it 'should override headers with option[:headers]' do
    get '/foo', { content_type: 'application/x-www-form-urlencoded' }

    expect(RestClient::Request).to have_received(:execute)
                            .with(:method => :get, :url => 'http://www.example.com/foo', 
                            :headers => { content_type: 'application/x-www-form-urlencoded' }, 
                            :verify_ssl => OpenSSL::SSL::VERIFY_NONE,
                            :timeout => 123)
  end

  it 'should override headers with airborne config headers' do
    Airborne.configure { |config| config.headers = { content_type: 'text/plain' } }

    get '/foo'

    expect(RestClient::Request).to have_received(:execute)
                            .with(:method => :get, :url => 'http://www.example.com/foo', 
                            :headers => { content_type: 'text/plain' },
                            :verify_ssl => OpenSSL::SSL::VERIFY_NONE,
                            :timeout => 123)
  end
end
