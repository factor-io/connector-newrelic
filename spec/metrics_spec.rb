require 'spec_helper'

require 'factor/connector/runtime'
require 'factor/connector/test'

describe NewRelicConnectorDefinition do
  it 'can summarize application metrics' do

    api_key = ENV['NEWRELIC_API_KEY'] || ENV['NEWRELIC_API']
    app_id  = ENV['NEWRELIC_APP_ID']

    @runtime = Factor::Connector::Runtime.new(NewRelicConnectorDefinition)
    params = {
      api_key: api_key,
      application: app_id,
      metrics: {
        'Apdex' => [ 'score' ]
      },
      range: {
        from: '2 weeks ago',
        to: '1 week ago'
      }
    }

    @runtime.run([:metrics,:summarize], params)

    expect(@runtime).to respond

    last = @runtime.logs.last

    expect(last).to be_a(Hash)
    expect(last).to include(:data)
    expect(last[:data]).to include('from')
    expect(last[:data]).to include('to')
    expect(last[:data]).to include('metrics')
    expect(last[:data]['metrics']).to be_a(Array)
    expect(last[:data]['metrics'].first).to include('name')
    expect(last[:data]['metrics'].first['name']).to eql('Apdex')
    expect(last[:data]['metrics'].first).to include('timeslices')
    expect(last[:data]['metrics'].first['timeslices']).to be_a(Array)
    expect(last[:data]['metrics'].first['timeslices'].first).to include('to')
    expect(last[:data]['metrics'].first['timeslices'].first).to include('from')
    expect(last[:data]['metrics'].first['timeslices'].first).to include('values')
    expect(last[:data]['metrics'].first['timeslices'].first['values']).to be_a(Hash)
    expect(last[:data]['metrics'].first['timeslices'].first['values']).to include('score')
  end
end