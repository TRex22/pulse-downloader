module Pulse
  module Downloader
    module FileDownloader
      # save_path and verify_ssl are defined in client.rb
      def download(url)
        raise "save_path is undefined" if save_data && save_path == ''

        @start_time = get_micro_second_time

        file_data = HTTParty.get(url, verify: verify_ssl)

        @end_time = get_micro_second_time

        if report_time
          print_time
        end

        if save_data
          File.open("#{save_path}/#{compute_filename(url)}", 'wb') do |file|
            file.write(file_data.body)
          end
        end

        file_data
      end

      def compute_hash_of(data)
        { data: data }.hash
      end
    end
  end
end
