module Pulse
  module Downloader
    module WebPageParser
      def fetch_file_paths(custom_path_root=nil)
        @start_time = get_micro_second_time

        response = HTTParty.get(url, verify: verify_ssl)

        @end_time = get_micro_second_time

        if report_time
          print_time
        end

        if file_type.is_a?(Array)
          file_type.flat_map do |type|
            extract_file_urls(response, custom_path_root, type)
          end
        else
          extract_file_urls(response, custom_path_root, file_type)
        end
      end

      private

      def extract_file_urls(response, custom_path_root, type)
        return [] if response.body.nil? || response.body.empty?
        (
          extract_download_links(response, custom_path_root, type) +
            extract_embedded_images(response, custom_path_root, type)
        ).uniq
      end

      def extract_download_links(response, custom_path_root, type)
        parse_html(response.body)
          .css('a')
          .to_a
          .map { |link| link['href'] }
          .compact
          .select { |link| (link.include? type || link.include?(custom_path_root)) }
          .map { |link| add_base_url(link) }
      end

      def extract_embedded_images(response, custom_path_root, type)
        return [] unless scrape_images

        parse_html(response.body)
          .css('img')
          .to_a
          .map { |e| e["src"] }
          .compact
          .select { |link| (link.include? type || link.include?(custom_path_root)) }
          .map { |link| add_base_url(link) }
      end

      def parse_html(raw_html)
        Nokogiri::HTML(raw_html)
      end

      def add_base_url(str)
        if !str.include?('https://') && !str.include?(base_url)
          "https://#{base_url}#{str}"
        else
          str
        end
      end
    end
  end
end
