# (c) Copyright IBM Corp. 2021
# (c) Copyright Instana Inc. 2021

module Instana
  module Activators
    class AwsS3 < Activator
      def can_instrument?
        defined?(Aws::S3::Client)
      end

      def instrument
        require 'instana/instrumentation/aws_sdk_s3'

        ::Aws::S3::Client.add_plugin(Instana::Instrumentation::S3)

        true
      end
    end
  end
end
