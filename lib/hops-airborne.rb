require 'airborne/optional_hash_type_expectations'
require 'airborne/path_matcher'
require 'airborne/request_expectations'
require 'airborne/rest_client_requester'
require 'airborne/rack_test_requester'
require 'airborne/base'
require 'openssl'

RSpec.configure do |config|
  config.add_setting :base_url
  config.add_setting :verify_ssl, default: OpenSSL::SSL::VERIFY_NONE
  config.add_setting :match_expected
  config.add_setting :match_actual
  config.add_setting :match_expected_default, default: true
  config.add_setting :match_actual_default, default: false
  config.add_setting :headers
  config.add_setting :rack_app
  config.add_setting :requester_type
  config.add_setting :requester_module
  config.add_setting :timeout, default: 60
  config.before do |example|
    config.match_expected = example.metadata[:match_expected].nil? ?
      Airborne.configuration.match_expected_default? : example.metadata[:match_expected]
    config.match_actual = example.metadata[:match_actual].nil? ?
      Airborne.configuration.match_actual_default? : example.metadata[:match_actual]
    config.timeout = example.metadata[:timeout].nil? ?
      Airborne.configuration.timeout? : example.metadata[:timeout]
  end

  # Include last since it depends on the configuration already being added
  config.include Airborne
end
