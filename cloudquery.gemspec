# frozen_string_literal: true

require_relative "lib/cloudquery/version"

Gem::Specification.new do |spec|
  spec.name = "cloudquery"
  spec.version = CloudqueryRails::VERSION
  spec.authors = ["Axel Mukwena"]
  spec.email = ["axel.muk@gmail.com"]

  spec.summary = "A Ruby wrapper around the Go-based Cloudquery, to automate executions"
  spec.description = "A Ruby wrapper to initiate and execute Cloudquery tasks."
  spec.homepage = "https://github.com/axelmukwena/cloudquery-rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/axelmukwena/cloudquery-rails"
  spec.metadata["changelog_uri"] = "https://github.com/axelmukwena/cloudquery-rails/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  # Add Go dependant files
  spec.files += Dir['lib/cloudquery.go']
  spec.files += Dir['lib/cloudquery.so']
  spec.files += Dir['lib/cloudquery.h']
  spec.files += Dir['lib/go.mod']

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_development_dependency  "rake", "~> 13.0"
  spec.add_development_dependency  "minitest", "~> 5.0"
  spec.add_development_dependency  "rubocop", "~> 1.21"
  spec.add_dependency  "ffi", "~> 1.15.5"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end