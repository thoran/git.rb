# test/Git/Branch_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Git/Branch'

describe Git::Branch do

  subject{Git::Branch}

  let(:git_branch_output) do
    <<~GIT_BRANCH_OUTPUT
      * master
      thoran/feat/awesome
      thoran/perf/lightspeed
    GIT_BRANCH_OUTPUT
  end

  describe ".command_string" do
    context "local" do
      it "produces the correct command string" do
        expect(subject.local.command_string).must_equal 'git branch'
      end
    end

    context "remote" do
      it "produces the correct command string" do
        expect(subject.remote.command_string).must_equal 'git branch --remote'
      end
    end

    context "merged" do
      it "produces the correct command string" do
        expect(subject.merged.command_string).must_equal 'git branch --merged'
      end
    end

    context "remote and merged" do
      it "produces the correct command string" do
        expect(subject.remote.merged.command_string).must_equal 'git branch --remote --merged'
      end
    end
  end

  describe ".all" do

    let(:branch_output){git_branch_output}

    it "outputs an array" do
      subject.stub(:branch_output, branch_output) do
        expect(subject.all.class).must_equal Array
      end
    end

    it "parses out the correct number of branches" do
      subject.stub(:branch_output, branch_output) do
        expect(subject.all.size).must_equal 3
      end
    end

    it "creates a Git::Branch object for each branch" do
      subject.stub(:branch_output, branch_output) do
        expect(subject.all.all?{|git_branch| git_branch.is_a?(Git::Branch)}).must_equal true
      end
    end

    it "correctly parses out the master branch when it is the current branch" do
      subject.stub(:branch_output, branch_output) do
        expect(subject.all.one?{|git_branch| git_branch.name == 'master'}).must_equal true
      end
    end
  end

  describe ".current" do

    let(:branch_output){git_branch_output}

    it "correctly parses out master as being the current branch" do
      subject.stub(:branch_output, branch_output) do
        expect(subject.current.name).must_equal 'master'
      end
    end
  end

end
