module Pulse
  module Downloader
    module WebPageParser
      def fetch_file_paths
        start_time = get_micro_second_time

        response = HTTParty.get(@path, verify: verify_ssl)

        # TODO: Use the time
        end_time = get_micro_second_time
        extract_file_urls(response, start_time, end_time)
      end

      private

      def extract_file_urls(response, start_time, end_time)
        parse_html(response)
          .css('a')
          .to_a
          .map { |link| link['href'] }
          .compact
          .select { |link| link.include? @file_type }
      end

      def parse_html(raw_html)
        Nokogiri::HTML(raw_html)
      end
    end
  end
end
