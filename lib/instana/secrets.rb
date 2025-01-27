# (c) Copyright IBM Corp. 2021
# (c) Copyright Instana Inc. 2021

require 'uri'
require 'cgi'

module Instana
  class Secrets
    def initialize(logger: ::Instana.logger)
      @logger = logger
    end

    def remove_from_query(str, secret_values = Instana.agent.secret_values)
      return str unless secret_values

      begin
        url = URI(str)
        params = url.scheme ? CGI.parse(url.query || '') : CGI.parse(url.to_s)

        redacted = redact(params, secret_values)

        url.query = URI.encode_www_form(redacted)
        url.scheme ? CGI.unescape(url.to_s) : CGI.unescape(url.query)
      rescue URI::InvalidURIError => _e
        params = CGI.parse(str || '')
        redacted = redact(params, secret_values)
        CGI.unescape(URI.encode_www_form(redacted))
      end
    end

    private

    def redact(params, secret_values)
      params.map do |k, v|
        needs_redaction = secret_values['list']
          .any? { |t| matcher(secret_values['matcher']).(t,k) }
        [k, needs_redaction ? '<redacted>' : v]
      end
    end

    def matcher(name)
      case name
      when 'equals-ignore-case'
        ->(expected, actual) { expected.casecmp(actual) == 0 }
      when 'equals'
        ->(expected, actual) { (expected <=> actual) == 0 }
      when 'contains-ignore-case'
        ->(expected, actual) { actual.downcase.include?(expected) }
      when 'contains'
        ->(expected, actual) { actual.include?(expected) }
      when 'regex'
        ->(expected, actual) { !Regexp.new(expected).match(actual).nil? }
      else
        @logger.warn("Matcher #{name} is not supported.")
        ->(_e, _a) { false }
      end
    end
  end
end
