module Pulse
  module Downloader
    class Client
      include ::Pulse::Downloader::WebPageParser
      include ::Pulse::Downloader::FileDownloader

      attr_reader :path, :file_type, :save_data, :save_path, :read_from_save_path, :verify_ssl

      # TODO: Readme and usage
      # TODO: Timing
      # TODO: Validation
      # TODO: Retry
      # TODO: Https skip certs
      # TODO: DNS
      def initialize(path:, file_type:, save_data: false, save_path: '', read_from_save_path: false, verify_ssl: true)
        @path = path
        @file_type = file_type
        @save_data = save_data
        @save_path = save_path
        @read_from_save_path = read_from_save_path
        @verify_ssl = verify_ssl
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
        (Time.now.to_f * 1000000).to_i
      end

      def compute_filename(file_path)
        file_path.scan(/[\/]\S+/).last
      end
    end
  end
end
