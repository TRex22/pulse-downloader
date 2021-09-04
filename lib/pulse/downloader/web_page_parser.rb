module Pulse
  module Downloader
    module WebPageParser
      def fetch_file_paths(custom_path_root=nil)
        if traverse_folders
          fetch_folders(url, custom_path_root).each do |folder_url|
            fetch_and_parse_response(folder_url, custom_path_root)
          end
        else
          fetch_and_parse_response(url, custom_path_root)
        end
      end

      private

      def fetch_folders(folder_url, custom_path_root)
        current_paths = extract_hrefs(get_response(folder_url), custom_path_root)

        @folder_urls = folder_urls.union(current_paths).uniq.compact

        current_paths.each do |path|
          fetch_folders(path, nil)
        end

        folder_urls
      end

      def fetch_and_parse_response(folder_url, custom_path_root)
        parse_response(get_response(folder_url), custom_path_root, file_type)
      end

      def get_response(folder_url)
        @start_time = get_micro_second_time

        response = HTTParty.get(folder_url, verify: verify_ssl, headers: headers)

        @end_time = get_micro_second_time

        if report_time
          print_time
        end

        response
      end

      def parse_response(response, custom_path_root, file_type)
        if file_type.is_a?(Array)
          file_type.flat_map do |type|
            extract_file_urls(response, custom_path_root, type)
          end
        else
          extract_file_urls(response, custom_path_root, file_type)
        end
      end

      def extract_file_urls(response, custom_path_root, type)
        return [] if response.body.nil? || response.body.empty?

        remove_artefacts(
          extract_all_urls(response, custom_path_root, type) +
            extract_download_links(response, type) +
            extract_embedded_images(response, type)
        ).uniq
      end

      def extract_hrefs(response, custom_path_root)
        parse_html(response.body)
          .css('a')
          .map { |link| "/#{link['href']}" }
          .reject { |link| link == "../" || link == "/../" }
          .reject { |link| link.include?('.') } # Remove files
          .map { |link| add_base_url(link, custom_path_root) }
      end

      def extract_all_urls(response, custom_path_root, type)
        parse_html(response.body)
          .to_s
          .split(/\s+/)
          .find_all { |u| u =~ /^https?:/ }
          .compact
          .select { |link| (link.include? type || link.include?(custom_path_root)) }
          .map { |link| add_base_url(link, custom_path_root) }
      end

      def extract_download_links(response, type)
        parse_html(response.body)
          .css('a')
          .to_a
          .map { |link| link['href'] }
          .compact
          .select { |link| (link.include? type) }
          .map { |link| add_base_url(link) }
      end

      def extract_embedded_images(response, type)
        return [] unless scrape_images

        parse_html(response.body)
          .css('img')
          .to_a
          .map { |e| e["src"] }
          .compact
          .select { |link| (link.include? type) }
          .map { |link| add_base_url(link) }
      end

      def remove_artefacts(urls)
        urls = remove_extra_escape_characters(urls)
        remove_base64(urls)
      end

      def remove_extra_escape_characters(urls)
        urls.map do |url|
          url.gsub("\">", '')
        end
      end

      def remove_base64(urls)
        urls.reject do |url|
          url.include?(':image/') || url.include?('base64')
        end
      end

      def parse_html(raw_html)
        Nokogiri::HTML(raw_html)
      end

      def add_base_url(str, custom_path_root=nil)
        return str if custom_path_root

        if !str.include?('https://') && !str.include?(base_url)
          "https://#{base_url}#{str}"
        else
          str
        end
      end
    end
  end
end
