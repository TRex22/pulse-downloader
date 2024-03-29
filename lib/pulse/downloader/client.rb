module Pulse
  module Downloader
    class Client
      require 'progress_bar'
      include ::Pulse::Downloader::WebPageParser
      include ::Pulse::Downloader::FileChecker
      include ::Pulse::Downloader::FileDownloader

      attr_reader :url,
        :file_type,
        :scrape_images,
        :save_data,
        :save_path,
        :read_from_save_path,
        :traverse_folders,
        :verify_ssl,
        :headers,
        :drop_exitsing_files_in_path,
        :save_and_dont_return,
        :report_time,
        :start_time,
        :end_time,
        :progress_bar,
        :base_url,
        :file_paths,
        :folder_urls

      # Does not continue downloads-
      # Will only save once the file has been downloaded in memory

      # TODO: Validation
      # TODO: Retry
      # TODO: DNS
      # TODO: lib/pulse/downloader/file_downloader.rb:13: warning: URI.escape is obsolete
      def initialize(url:,
        file_type:,
        scrape_images: false,
        save_data: false,
        save_path: '',
        read_from_save_path: false,
        traverse_folders: false,
        verify_ssl: true,
        headers: nil,
        drop_exitsing_files_in_path: false,
        save_and_dont_return: true,
        report_time: false,
        progress_bar: false)

        @url = url
        @file_type = file_type
        @scrape_images = scrape_images
        @save_data = save_data
        @save_path = save_path
        @read_from_save_path = read_from_save_path
        @traverse_folders = traverse_folders
        @verify_ssl = verify_ssl
        @headers = headers
        @drop_exitsing_files_in_path = drop_exitsing_files_in_path
        @save_and_dont_return = save_and_dont_return
        @report_time = report_time
        @progress_bar = progress_bar

        @base_url = get_base_url
        @folder_urls = []
      end

      def call!
        call
      end

      def call
        return false unless valid?

        @file_paths = fetch_file_paths

        if @progress_bar
          @progress_bar = ::ProgressBar.new(file_paths.size)
        end

        file_paths.map do |file_path|
          download(file_path, @progress_bar) if save_data
          @progress_bar.increment!
        end
      end

      def valid?
        true # TODO
      end

      private

      def get_base_url
        url_breakdown = url.split('/')

        if url_breakdown.first.include?('https')
          url_breakdown[2]
        else
          url_breakdown.first
        end
      end

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
