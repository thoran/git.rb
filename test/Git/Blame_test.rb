# test/Git/Blame_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Git/Blame'

describe Git::Blame do

  let(:git_blame_output) do
    git_blame_output_filename = File.expand_path(File.join(__FILE__, '..', '..', 'fixtures', 'git_blame_output.txt'))
    File.read(git_blame_output_filename)
  end

  describe "#command_string" do
    context "line_number given" do
      subject{Git::Blame.new(filename, line_number).command_string}

      let(:filename){'path/to/file'}
      let(:line_number){100}

      it "constructs the correct command string" do
        expect(subject).must_equal "git --no-pager blame -L 100,100 path/to/file --line-porcelain"
      end
    end

    context "line_number not given" do
      subject{Git::Blame.new(filename).command_string}

      let(:filename){'path/to/file'}

      it "constructs the correct command string" do
        expect(subject).must_equal "git --no-pager blame path/to/file --line-porcelain"
      end

    end
  end

  describe "#entries" do
    subject{Git::Blame.new('dummy_filename.rb')}

    let(:blame_output){git_blame_output}

    it "returns an array of PorcelainEntry objects" do
      subject.stub(:blame_output, blame_output) do
        expect(subject.entries.count).must_equal 39
      end
    end
  end

  describe "#find" do
    subject{Git::Blame.new('dummy_filename.rb')}

    let(:blame_output){git_blame_output}

    it "finds the correct line given a line number" do
      subject.stub(:blame_output, blame_output) do
        expect(subject.find(34).class).must_equal Git::Blame::PorcelainEntry

        expect(subject.find(34).instance_variable_get("@author_mail")).must_equal '<code@thoran.com>'
        expect(subject.find(34).instance_variable_get("@author_time")).must_equal '1513236528'

        expect(subject.find(34).author_mail).must_equal '<code@thoran.com>'
        expect(subject.find(34).author_time).must_equal '1513236528'
      end
    end
  end

end
