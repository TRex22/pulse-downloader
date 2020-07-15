module Pulse
  module Downloader
    class Client
      include ::Pulse::Downloader::WebPageParser
      include ::Pulse::Downloader::FileDownloader

      attr_reader :url,
        :file_type,
        :save_data,
        :save_path,
        :read_from_save_path,
        :verify_ssl,
        :report_time,
        :start_time,
        :end_time

      # TODO: Add in progress bar
      # TODO: Validation
      # TODO: Retry
      # TODO: DNS
      def initialize(url:, file_type:, save_data: false, save_path: '', read_from_save_path: false, verify_ssl: true, report_time: false)
        @url = url
        @file_type = file_type
        @save_data = save_data
        @save_path = save_path
        @read_from_save_path = read_from_save_path
        @verify_ssl = verify_ssl
        @report_time = report_time
      end

      def call!
        call
      end

      def call
        return false unless valid?

        fetch_file_paths.map do |file_path|
          download(file_path)
        end
      end

      def valid?
        true # TODO
      end

      private

      def get_micro_second_time
        (Time.now.to_f * 1000).to_i
      end

      def print_time
        puts "Request time: #{end_time - start_time} ms."
      end
    end
  end
end
