# test/Git/Branch_test.rb

require_relative '../helper'

require 'Git/Branch'

describe Git::Branch do

  subject{Git::Branch}

  let(:branch_output) do
    branch_output_filename = File.expand_path(File.join(__FILE__, '..', '..', 'fixtures', 'branch_output.txt'))
    File.read(branch_output_filename)
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

  describe ".remote.all" do
    let(:remote_branch_output) do
      remote_branch_output_filename = File.expand_path(File.join(__FILE__, '..', '..', 'fixtures', 'remote_branch_output.txt'))
      File.read(remote_branch_output_filename)
    end

    it "runs git branch --remote" do
      commands = []
      subject.stub(:`, ->(command){commands << command; remote_branch_output}) do
        subject.remote.all
      end
      expect(commands).must_equal ['git branch --remote']
    end

    it "leaves out the remote's HEAD, which names another branch" do
      subject.stub(:`, remote_branch_output) do
        expect(subject.remote.all.collect{|git_branch| git_branch.name}).must_equal ['master', 'thoran/feat/awesome']
      end
    end

    it "gives each branch its remote" do
      subject.stub(:`, remote_branch_output) do
        expect(subject.remote.all.collect{|git_branch| git_branch.remote}).must_equal ['origin', 'origin']
      end
    end
  end

  describe "#merged?" do
    let(:merged_output) do
      <<~GIT_BRANCH_OUTPUT
          origin/HEAD -> origin/master
          origin/master
      GIT_BRANCH_OUTPUT
    end

    context "a remote branch which is merged" do
      it "returns true" do
        subject.stub(:`, merged_output) do
          expect(Git::Branch.new('master', remote: 'origin').merged?).must_equal true
        end
      end
    end

    context "a remote branch which isn't merged" do
      it "returns false" do
        subject.stub(:`, merged_output) do
          expect(Git::Branch.new('thoran/feat/awesome', remote: 'origin').merged?).must_equal false
        end
      end
    end
  end

  describe ".current" do
    it "correctly parses out master as being the current branch" do
      subject.stub(:branch_output, branch_output) do
        expect(subject.current.name).must_equal 'master'
      end
    end
  end

  describe "#method_missing" do
    context "current branch is master" do
      it "returns true" do
        subject.stub(:branch_output, branch_output) do
          expect(subject.current.master?).must_equal true
        end
      end
    end

    context "current branch is NOT master" do
      let(:branch_output) do
        <<~GIT_BRANCH_OUTPUT
          master
          * thoran/feat/awesome
          thoran/perf/lightspeed
        GIT_BRANCH_OUTPUT
      end

      it "returns true" do
        subject.stub(:branch_output, branch_output) do
          expect(subject.current.master?).must_equal false
        end
      end
    end
  end
end
