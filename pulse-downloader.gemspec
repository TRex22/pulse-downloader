require_relative 'lib/pulse/downloader/version'

Gem::Specification.new do |spec|
  spec.name          = "pulse-downloader"
  spec.version       = Pulse::Downloader::VERSION
  spec.authors       = ["trex22"]
  spec.email         = ["contact@jasonchalom.com"]

  spec.summary       = "Client to download datasets from webpages."
  spec.description   = "Client to download datasets from webpages."
  spec.homepage      = "https://github.com/TRex22/pulse-downloader"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.18"
  spec.add_dependency "active_attr", "~> 0.15"
  spec.add_dependency "nokogiri", "~> 1.10.9"

  # Development dependancies
  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-focus", "~> 1.1.2"
  spec.add_development_dependency "minitest-reporters", "~> 1.4.2"
  spec.add_development_dependency "timecop", "~> 0.9.1"
  spec.add_development_dependency "mocha", "~> 1.11.2"
  spec.add_development_dependency "pry", "~> 0.13"
  spec.add_development_dependency "webmock", "~> 3.8.3"
end
