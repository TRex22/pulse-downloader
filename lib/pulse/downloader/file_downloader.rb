module Pulse
  module Downloader
    module FileDownloader
      require 'uri'

      # save_path and verify_ssl are defined in client.rb
      def download(file_path, progress_bar=nil)
        raise "save_path is undefined" if save_data && save_path == ''
        return if file_path_in_file_list?(file_path) # skip downloading the file

        @start_time = get_micro_second_time

        file_data = HTTParty.get(compute_file_link(file_path), verify: verify_ssl)

        @end_time = get_micro_second_time

        if report_time
          print_time(progress_bar)
        end

        if save_data
          File.open(compute_save_path(file_path), 'wb') do |file|
            file.write(file_data.body)
          end

          return true if save_and_dont_return
        end

        file_data
      end

      def fetch_save_paths
        fetch_file_paths.map do |file_path|
          "#{save_path}/#{compute_filename(file_path)}"
        end
      end

      def compute_hash_of(data)
        { data: data }.hash
      end

      private

      def compute_file_link(file_path)
        if section?(file_path)
          raise 'invalid download path'
        elsif absolute?(file_path)
          file_path
        elsif relative?(file_path)
          "#{url}/#{file_path}"
        else
          "#{url}/#{file_path}"
        end
      end

      def absolute?(file_path)
        file_path.include?('http://') ||
          file_path.include?('https://') ||
          file_path.include?('ftp://') ||
          file_path.include?('sftp://')||
          file_path.include?('file://')
      end

      def relative?(file_path)
        file_path[0] == '/'
      end

      def section?(file_path)
        file_path[0] == '#'
      end
    end
  end
end
