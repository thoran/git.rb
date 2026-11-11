require_relative './lib/Git/VERSION'

Gem::Specification.new do |spec|
  spec.name = 'git.rb'
  spec.version = Git::VERSION

  spec.summary = "Do git stuff from Ruby."
  spec.description = "Do stuff with git-blame, git-branch, git-log, and git-remote from Ruby."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/git.rb'
  spec.license = 'MIT'

  spec.files = [
    'git.rb.gemspec',
    Dir['lib/**/*.rb'],
    Dir['test/**/*.rb'],
    Dir['test/fixtures/*.txt'],
    'CHANGELOG',
    'Gemfile',
    'LICENSE',
    'Rakefile',
    'README.md',
    'TODO',
  ].flatten
  spec.required_ruby_version = '>= 2.1'

  spec.add_development_dependency('minitest')
  spec.add_development_dependency('minitest-mock')
  spec.add_development_dependency('minitest-spec-context')
  spec.add_development_dependency('rake')
end
