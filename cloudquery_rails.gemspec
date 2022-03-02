# frozen_string_literal: true

require_relative "lib/cloudquery_rails/version"

Gem::Specification.new do |spec|
  spec.name = "cloudquery_rails"
  spec.version = CloudqueryRails::VERSION
  spec.authors = ["Axel Mukwena"]
  spec.email = ["axel.muk@gmail.com"]

  spec.summary = "A Ruby wrapper around the Go-based Cloudquery, to automate executions"
  spec.description = "A Ruby wrapper around the Go-based Cloudquery, to automate executions"
  spec.homepage = "https://github.com/axelmukwena/cloudquery_rails"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/axelmukwena/cloudquery_rails"
  spec.metadata["changelog_uri"] = "https://github.com/axelmukwena/cloudquery_rails/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
