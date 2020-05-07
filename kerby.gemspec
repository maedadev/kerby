require_relative 'lib/kerby/version'

Gem::Specification.new do |spec|
  spec.name          = "kerby"
  spec.version       = Kerby::VERSION
  spec.authors       = ["ido"]
  spec.email         = ["f-ido@lab.acs-jp.com"]

  spec.summary       = %q{Kubernetes ERB support on Yaml manifest files.}
  spec.description   = %q{Kubernetes ERB support on Yaml manifest files.}
  spec.homepage      = "https://github.com/maedadev"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "thor"
  spec.add_development_dependency "byebug"
end
