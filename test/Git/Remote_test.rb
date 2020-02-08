# test/Git/Remote_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Git/Remote'

describe Git::Remote do

  let(:remote_output) do
    'origin  git@github.com:thoran/rails.git (fetch)
     origin  git@github.com:thoran/rails.git (push)
     upstream  git@github.com:rails/rails.git (fetch)
     upstream  git@github.com:rails/rails.git (push)'
  end

  describe ".parse_line" do
    subject{Git::Remote.parse_line(remote_output_line)}

    let(:remote_output_line){'origin  git@github.com:thoran/rails.git (fetch)'}

    it " parses the name and url and returns an instance of Git::Remote" do
      expect(subject.class).must_equal Git::Remote
      expect(subject.name).must_equal 'origin'
      expect(subject.url).must_equal 'git@github.com:thoran/rails.git'
    end
  end

  describe ".all" do
    subject{Git::Remote.all}

    it "returns out the correct number of remotes" do
      Git::Remote.stub(:remote_output, remote_output) do
        expect(subject.size).must_equal 2
      end
    end

    it "returns a Git::Remote object for each remote" do
      Git::Remote.stub(:remote_output, remote_output) do
        expect(subject.all? do |candidate_git_remote_instance|
          candidate_git_remote_instance.is_a?(Git::Remote)
        end).must_equal true
      end
    end
  end

  describe ".find" do
    subject{Git::Remote.find(remote_name)}

    let(:remote_name){'origin'}

    it "finds a remote by name" do
      Git::Remote.stub(:remote_output, remote_output) do
        expect(subject.class).must_equal Git::Remote
        expect(subject.name).must_equal 'origin'
        expect(subject.url).must_equal 'git@github.com:thoran/rails.git'
      end
    end
  end

  describe ".add_command" do
    subject{Git::Remote.add_command(nom, url)}

    let(:nom){'name'}
    let(:url){'git@github.com:thoran/rails.git'}

    it "constructs an add command" do
      expect(subject).must_equal 'git remote add name git@github.com:thoran/rails.git'
    end
  end

  describe ".remove_command" do
    subject{Git::Remote.remove_command(nom)}

    let(:nom){'name'}

    it "constructs a remove command" do
      expect(subject).must_equal 'git remote remove name'
    end
  end

  describe ".exist?" do
    subject{Git::Remote.exist?('origin')}

    it "finds a remote by name" do
      Git::Remote.stub(:remote_output, remote_output) do
        expect(subject).must_equal true
      end
    end
  end

end
