# test/Git/VERSION_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'git.rb'

describe Git do
  describe "VERSION" do
    it "is a string" do
      _(Git::VERSION).must_be_instance_of String
    end

    it "is three numbers separated by dots" do
      _(Git::VERSION).must_match(/\A\d+\.\d+\.\d+\z/)
    end

    it "matches the newest entry in the CHANGELOG" do
      changelog = File.read(File.expand_path('../../CHANGELOG.md', __dir__))
      _(changelog[/^## (\d+\.\d+\.\d+) \(/, 1]).must_equal Git::VERSION
    end
  end
end
