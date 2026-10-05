# test/loading_test.rb

require 'minitest/autorun'

require_relative '../lib/git'

# In its own process, since this one has loaded the file directly and so could
# not tell what requiring the gem by its own name would bring.
describe 'loading' do
  def ruby(source)
    lib = File.expand_path('../lib', __dir__)
    IO.popen(['ruby', "-I#{lib}", '-e', source], err: [:child, :out]){|io| io.read}.strip
  end

  # The gem is git.rb, so require 'git.rb' reads lib/git.rb.  A capitalised
  # load file answers that only on a case-insensitive filesystem, which is to say
  # on the machine it was written on and not on Linux.  Dir.entries reports the
  # name as stored, so this asks what a case-sensitive filesystem would ask.
  it "carries the lowercase file the gem's name asks for" do
    _(Dir.entries(File.expand_path('../lib', __dir__))).must_include 'git.rb'
  end

  it "defines Git upon requiring the gem by name" do
    _(ruby('require "git.rb"; print defined?(Git)')).must_equal 'constant'
  end

  it "defines the version too" do
    _(ruby('require "git.rb"; print Git::VERSION')).must_equal Git::VERSION
  end
end
