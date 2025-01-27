# (c) Copyright IBM Corp. 2021
# (c) Copyright Instana Inc. 2021

module Instana
  module Activators
    class AwsSdkSqs < Activator
      def can_instrument?
        defined?(Aws::SQS::Client)
      end

      def instrument
        require 'instana/instrumentation/aws_sdk_sqs'

        ::Aws::SQS::Client.add_plugin(Instana::Instrumentation::SQS)

        true
      end
    end
  end
end
