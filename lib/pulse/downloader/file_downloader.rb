module Pulse
  module Downloader
    module FileDownloader
      # save_path and verify_ssl are defined in client.rb
      def download(file_path)
        raise "save_path is undefined" if save_data && save_path == ''

        @start_time = get_micro_second_time

        file_data = HTTParty.get(compute_file_link(file_path), verify: verify_ssl)

        @end_time = get_micro_second_time

        if report_time
          print_time
        end

        if save_data
          File.open(compute_save_path(file_path), 'wb') do |file|
            file.write(file_data.body)
          end
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

      def compute_save_path(url)
        "#{save_path}/#{compute_filename(url)}"
      end

      def compute_filename(file_path)
        file_path.scan(/[\/]\S+/).last
      end

      def compute_file_link(file_path)
        if file_path[0] == '/'
          "#{url}/#{file_path}"
        else
          file_path
        end
      end
    end
  end
end
