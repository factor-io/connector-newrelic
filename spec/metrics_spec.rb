require 'spec_helper'

describe 'Metrics' do
  it 'can sumarize application metrics' do

    api_key = ENV['NEWRELIC_API']
    app_id  = ENV['NEWRELIC_APP_ID']

    service_instance = service_instance('newrelic_metrics')

    params = {
      'api_key' => api_key,
      'application' => app_id,
      'metrics' => {
        'Apdex' => [ 'score' ]
      },
      'range' => {
        'from' => '2 weeks ago',
        'to' => '1 week ago'
      }
    }

    service_instance.test_action('summarize', params) do
      response = expect_return

      expect(response).to be_a(Hash)
      expect(response).to include(:payload)
      expect(response[:payload]).to include('from')
      expect(response[:payload]).to include('to')
      expect(response[:payload]).to include('metrics')
      expect(response[:payload]['metrics']).to be_a(Array)
      expect(response[:payload]['metrics'].first).to include('name')
      expect(response[:payload]['metrics'].first['name']).to eql('Apdex')
      expect(response[:payload]['metrics'].first).to include('timeslices')
      expect(response[:payload]['metrics'].first['timeslices']).to be_a(Array)
      expect(response[:payload]['metrics'].first['timeslices'].first).to include('to')
      expect(response[:payload]['metrics'].first['timeslices'].first).to include('from')
      expect(response[:payload]['metrics'].first['timeslices'].first).to include('values')
      expect(response[:payload]['metrics'].first['timeslices'].first['values']).to be_a(Hash)
      expect(response[:payload]['metrics'].first['timeslices'].first['values']).to include('score')
    end
  end
end