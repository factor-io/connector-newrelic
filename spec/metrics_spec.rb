require 'spec_helper'

describe 'Metrics' do
  it 'can sumarize application metrics' do

    api_key = ENV['NEWRELIC_API']

    service_instance = service_instance('newrelic_metrics')

    params = {
      'api_key' => api_key,
      'metrics' => {
        'Apdex' => [ 'score' ]
      },
      'range' => {
        'from': '2 weeks ago',
        'to': '1 week ago'
      }
    }

    service_instance.test_action('summarize',params) do
      expect_return
    end

  end
end