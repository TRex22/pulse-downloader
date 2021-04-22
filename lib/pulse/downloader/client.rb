module Pulse
  module Downloader
    class Client
      require 'progress_bar'
      include ::Pulse::Downloader::WebPageParser
      include ::Pulse::Downloader::FileChecker
      include ::Pulse::Downloader::FileDownloader

      attr_reader :url,
        :file_type,
        :save_data,
        :save_path,
        :read_from_save_path,
        :verify_ssl,
        :drop_exitsing_files_in_path,
        :save_and_dont_return,
        :report_time,
        :start_time,
        :end_time,
        :progress_bar

      # Does not continue downloads-
      # Will only save once the file has been downloaded in memory

      # TODO: Validation
      # TODO: Retry
      # TODO: DNS
      def initialize(url:,
        file_type:,
        save_data: false,
        save_path: '',
        read_from_save_path: false,
        verify_ssl: true,
        drop_exitsing_files_in_path: false,
        save_and_dont_return: true,
        report_time: false,
        progress_bar: false)

        @url = url
        @file_type = file_type
        @save_data = save_data
        @save_path = save_path
        @read_from_save_path = read_from_save_path
        @verify_ssl = verify_ssl
        @drop_exitsing_files_in_path = drop_exitsing_files_in_path
        @save_and_dont_return = save_and_dont_return
        @report_time = report_time
        @progress_bar = progress_bar
      end

      def call!
        call
      end

      def call
        return false unless valid?

        if @progress_bar
          @progress_bar = ::ProgressBar.new(fetch_file_paths.size)
        end

        fetch_file_paths.map do |file_path|
          download(file_path, @progress_bar)
          @progress_bar.increment!
        end
      end

      def valid?
        true # TODO
      end

      private

      def get_micro_second_time
        (Time.now.to_f * 1000).to_i
      end

      def print_time(progress_bar=nil)
        output = "Request time: #{end_time - start_time} ms."

        if progress_bar
          progress_bar.puts output
        else
          puts output
        end
      end
    end
  end
end
