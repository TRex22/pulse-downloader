require 'httparty'
require 'nokogiri'

require "pulse/downloader/version"
require 'pulse/downloader/web_page_parser'
require 'pulse/downloader/file_downloader'
require 'pulse/downloader/client'

module Pulse
  module Downloader
    class Error < StandardError; end
  end
end
