# (c) Copyright IBM Corp. 2021
# (c) Copyright Instana Inc. 2021

module Instana
  module Activators
    class Redis < Activator
      def can_instrument?
        defined?(::Redis) && ::Instana.config[:redis][:enabled]
      end

      def instrument
        require 'instana/instrumentation/redis'

        ::Redis::Client.prepend(::Instana::RedisInstrumentation)

        true
      end
    end
  end
end
