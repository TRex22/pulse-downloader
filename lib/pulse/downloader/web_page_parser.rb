module Pulse
  module Downloader
    module WebPageParser
      def fetch_file_paths
        @start_time = get_micro_second_time

        response = HTTParty.get(url, verify: verify_ssl)

        @end_time = get_micro_second_time

        if report_time
          print_time
        end

        extract_file_urls(response)
      end

      private

      def extract_file_urls(response)
        return [] if response.body.nil? || response.body.empty?
        extract_download_links(response) + extract_embedded_images(response)
      end

      def extract_download_links(response)
        parse_html(response.body)
          .css('a')
          .to_a
          .map { |link| link['href'] }
          .compact
          .select { |link| link.include? file_type }
          .map { |link| add_base_url(link) }
      end

      def extract_embedded_images(response)
        return [] unless scrape_images

        parse_html(response.body)
          .css('img')
          .to_a
          .map { |e| e["src"] }
          .compact
          .select { |link| link.include? file_type }
          .map { |link| add_base_url(link) }
      end

      def parse_html(raw_html)
        Nokogiri::HTML(raw_html)
      end

      def add_base_url(str)
        "#{base_url}#{str}"
      end
    end
  end
end
