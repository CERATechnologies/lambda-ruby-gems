# frozen_string_literal: true

require 'json'

module Oculo
  module SnsEvents

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
        @payload = event.dig('Records', 0, 'Sns', 'Message').then { |msg| JSON.parse(msg) }
      end

      attr_reader :payload

      def file_key
        @file_key ||= payload.dig('Records', 0, 's3', 'object', 'key')
      end

      def file_size
        @file_size ||= payload.dig('Records', 0, 's3', 'object', 'size')
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
      # @return [Boolean]
      def matches_extensions?(*file_extensions)
        file_key.end_with?(*file_extensions)
      end

      ##
      # Does the file from S3 located in this directory?
      #
      # @param prefix [String] S3 key prefix
      # @return [Boolean]
      def has_path?(prefix)
        file_key.start_with?(prefix.sub(%r[^/], ''))
      end
    end

  end
end
