# frozen_string_literal: true

require 'json'

module Oculo
  module SnsEvents
    class InvalidSnsS3EventError < StandardError; end

    ##
    # Usage:
    #
    # ```
    #   s3_event = Oculo::SnsEvents::S3Notification.new(event: event)
    #   return unless s3_event.has_path?('/my/path') && s3_event.matches_extensions?('.jpg', '.jpeg')
    #   do_something(s3_event.payload)
    #   ...
    # ```
    class S3Notification
      def initialize(event:)
        @event = event
      end

      ##
      # Get the S3 Payload extracted from the SNS Event
      #
      # @raise [InvalidSnsS3EventError] if the payloads could not be parsed
      # @return [Hash] the decoded message
      def payload
        @payload ||=
          @event.dig('Records', 0, 'Sns', 'Message')
            .tap { |msg| raise InvalidSnsS3EventError if msg.nil? }
            .then { |msg| JSON.parse(msg) }
      end

      def s3_test_message?
        payload['Event'] == 's3:TestEvent'
      end

      def file_key
        return nil if s3_test_message?

        @file_key ||= s3_object_value('key')
      end

      def file_size
        return nil if s3_test_message?

        @file_size ||= s3_object_value('size')
      end

      ##
      # Does the S3 file match any of these file extensions?
      #
      # @overload matches_extensions?(file_extension)
      #   @param file_extension [String] the extension to check for
      #
      # @overload matches_extensions?(ext1, ext2, ... )
      #   @param ext1 [String] check for this extension
      #   @param ext1 [String] and this one too
      #          ...
      #
      # @raise [InvalidSnsS3EventError] if the payloads could not be parsed
      # @return [Boolean]
      def matches_extensions?(*file_extensions)
        file_key&.end_with?(*file_extensions) || false
      end

      ##
      # Does the file from S3 located in this directory?
      #
      # @param prefix [String] S3 key prefix
      # @raise [InvalidSnsS3EventError] if the payloads could not be parsed
      # @return [Boolean]
      def has_path?(prefix)
        file_key&.start_with?(prefix.sub(%r[^/], '')) || false
      end

      private

      def s3_object_value(key)
        payload.dig('Records', 0, 's3', 'object', key).tap {|value| raise InvalidSnsS3EventError if value.nil?}
      end
    end
  end
end
