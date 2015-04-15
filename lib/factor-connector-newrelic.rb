require 'factor/connector/definition'
require 'newrelic-metrics'
require 'chronic'

class NewRelicConnectorDefinition < Factor::Connector::Definition
  id :new_relic

  resource :metrics do
    action :summarize do |params|
      api_key   = params[:api_key]
      server_id = params[:server]
      app_id    = params[:application]
      metrics   = params[:metrics]
      range     = params[:range]
      summarize = params[:summarize] || false

      fail "API Key (api_key) is required" unless api_key
      fail "Server ID (server) or Application ID (application) is required" unless server_id || app_id
      fail "Server ID (server) or Application ID (application) is required, but not both" if server_id && app_id

      fail "Metrics (metrics) is required" unless metrics
      fail "Metrics (metrics) must be a hash" unless metrics.is_a?(Hash)
      fail "Metrics (metrics) keys must all be strings" unless metrics.keys.all?{|k| k.is_a?(String)}
      fail "Metrics (metrics) values must all be arrays of string" unless metrics.values.all?{|value| value.is_a?(Array) && value.all?{|i| i.is_a?(String)} }

      if range
        fail "Range (range) must have a from date" unless range[:from]
        fail "Range (range) 'from' time must be a String" unless range[:from].is_a?(String)
        fail "Range (range) 'from' time is invalid" unless Chronic.parse(range[:from], context: :past)
        if range['to']
          fail "Range (range) 'to' time must be a String" unless range[:to].is_a?(String)
          fail "Range (range) 'to' time is invalid" unless Chronic.parse(range[:to], context: :past)
        end
      end

      option = {}
      option[:server] = server_id if server_id
      option[:application] = app_id if app_id

      info "Pulling data from New Relic"
      begin
        config = NewRelicMetrics::Configuration.new
        config.api_key = api_key
        api = NewRelicMetrics::Client.new(config)
        query = option.merge(metrics:metrics, range:range, summarize: summarize)
        data = api.metrics(query)
      rescue => ex
        fail "Failed to collect data from New Relic", exception: ex
      end

      respond data

    end
  end
end