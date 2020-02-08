Gem::Specification.new do |spec|
  spec.name = 'git.rb'
  spec.version = '0.10.0'
  spec.date = '2020-02-08'

  spec.summary = "Do git stuff from Ruby."
  spec.description = "Do stuff with git-blame, git-branch, git-log, and git-remote from Ruby."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/git.rb'
  spec.license = 'MIT'

  spec.files = Dir['lib/**/*.rb']
  spec.required_ruby_version = '>= 1.9.3'
end
