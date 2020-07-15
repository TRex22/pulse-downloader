module Pulse
  module Downloader
    module FileDownloader
      # save_path are defined in client.rb
      def download(file_path)
        raise "save_path is undefined" if save_data && save_path == ''

        start_time = get_micro_second_time

        file_data = HTTParty.get(file_path)

        # TODO: Use the time
        end_time = get_micro_second_time

        if save_data
          File.open("#{save_path}/#{compute_filename(file_path)}", 'wb') do |file|
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
