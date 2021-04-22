module Pulse
  module Downloader
    module FileChecker
      def file_path_in_file_list?(file_path)
        return false unless drop_exitsing_files_in_path && save_data

        list_files_in(save_path).include?(compute_save_path(file_path))
      end

      private

      def compute_save_path(url)
        "#{save_path}/#{compute_filename(url)}".gsub('//', '/').gsub(' ', '')
      end

      def compute_filename(file_path)
        file_path.scan(/[\/]\S+/).last
      end

      def list_files_in(path)
        `ls #{path}`.split("\n").map do |filename|
          "#{path}/#{filename}".gsub('//', '/')
        end
      end
    end
  end
end
