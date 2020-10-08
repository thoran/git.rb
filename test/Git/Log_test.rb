# test/Git/Log_test.rb

gem 'minitest'
gem 'minitest-spec-context'

require 'minitest/autorun'
require 'minitest-spec-context'

lib_dir = File.expand_path(File.join(__FILE__, '..', '..', '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Git/Log'

describe Git::Log do
  describe ".parse" do
    context "without a merge commit" do
      subject{Git::Log.parse(log_stream)}

      let(:log_stream) do
        <<~LOG_STREAM
          commit ab550dc384cd9d49b1f1586ff957893988c04d22
          Author: thoran <code@thoran.com>
          Date:   Fri Nov 16 12:39:53 2012 +1100
          
              Commit #4.
          
          commit 15ab28c017d422ae98065f5674ac837f7bc7adb1
          Author: thoran <code@thoran.com>
          Date:   Thu Nov 8 16:02:26 2012 +1100
          
              Commit #3.
          
          commit 236f6ff09863d68289d89ee467dd4e450eb22295
          Author: thoran <code@thoran.com>
          Date:   Thu Nov 8 15:54:59 2012 +1100
          
              Commit #2.
          
          commit c39a4d62bd79969e3e9033a7573943b24cd81cd9
          Author: thoran <code@thoran.com>
          Date:   Fri Oct 26 21:23:47 2012 +1100
          
              Commit #1.
        LOG_STREAM
      end

      it "parses out the correct number of commits" do
        expect(subject.size).must_equal 4
      end

      it "creates a Git::Log::Commit object for each commit" do
        expect(subject.all?{|candidate_git_log_commit| candidate_git_log_commit.is_a?(Git::Log::Commit)}).must_equal true
      end
    end

    context "with a merge commit" do
      subject{Git::Log.parse(log_stream)}

      let(:log_stream) do
        <<~LOG_STREAM
          commit ab550dc384cd9d49b1f1586ff957893988c04d22
          Author: thoran <code@thoran.com>
          Date:   Fri Nov 16 12:39:53 2012 +1100
          
              Commit #4.
          
          commit 15ab28c017d422ae98065f5674ac837f7bc7adb1
          Merge: 2026aed13g 74a989083c
          Author: thoran <code@thoran.com>
          Date:   Thu Nov 8 16:02:26 2012 +1100
          
              Commit #3.
          
          commit 236f6ff09863d68289d89ee467dd4e450eb22295
          Author: thoran <code@thoran.com>
          Date:   Thu Nov 8 15:54:59 2012 +1100
          
              Commit #2.
          
          commit c39a4d62bd79969e3e9033a7573943b24cd81cd9
          Author: thoran <code@thoran.com>
          Date:   Fri Oct 26 21:23:47 2012 +1100
          
              Commit #1.
        LOG_STREAM
      end

      it "parses out the correct number of commits" do
        expect(subject.size).must_equal 4
      end

      it "creates a Git::Log::Commit object for each commit" do
        expect(subject.all?{|candidate_git_log_commit| candidate_git_log_commit.is_a?(Git::Log::Commit)}).must_equal true
      end
    end

    context "with a larger number of merge commits" do
      subject{Git::Log.parse(log_output)}

      let(:log_output) do
        git_log_output_filename = File.expand_path(File.join(__FILE__, '..', '..', 'fixtures', 'git_log_output.txt'))
        File.read(git_log_output_filename)
      end

      it "parses out the correct number of commits" do
        expect(subject.size).must_equal 11
      end

      it "creates a Git::Log::Commit object for each commit" do
        expect(subject.all?{|candidate_git_log_commit| candidate_git_log_commit.is_a?(Git::Log::Commit)}).must_equal true
      end
    end
  end
end

describe Git::Log::Commit do
  describe ".parse" do
    context "without a merge commit" do
      subject{Git::Log::Commit.parse(commit_string)}

      let(:commit_string) do
        <<~COMMIT_STRING
          commit ab550dc384cd9d49b1f1586ff957893988c04d22
          Author: thoran <code@thoran.com>
          Date:   Fri Nov 16 12:39:53 2012 +1100
          
              Commit #4.
        COMMIT_STRING
      end

      it "parses out the git hash" do
        expect(subject.hash).must_equal 'ab550dc384cd9d49b1f1586ff957893988c04d22'
      end

      it "parses out the author" do
        expect(subject.author).must_equal 'thoran <code@thoran.com>'
      end

      it "parses out the date" do
        expect(subject.date).must_equal 'Fri Nov 16 12:39:53 2012 +1100'
      end

      it "parses out the commit message" do
        expect(subject.message).must_equal 'Commit #4.'
      end
    end

    context "with a merge commit" do
      subject{Git::Log::Commit.parse(commit_string)}

      let(:commit_string) do
        <<~COMMIT_STRING
          commit f747fc11aedac304e0db0326e48758f5d77687fc (HEAD -> main, origin/release/staging, origin/main, origin/HEAD)
          Merge: 2026aed13f 74a989083b
          Author: Dev1 <dev1@example.com>
          Date:   Tue Sep 29 13:42:38 2020 +1000

            Merge pull request #4 from my/feature/branch
            
            fix: confusing wording.
        COMMIT_STRING
      end

      it "parses out the git hash" do
        expect(subject.hash).must_equal 'f747fc11aedac304e0db0326e48758f5d77687fc'
      end

      it "parses out the git merge" do
        expect(subject.merge).must_equal '2026aed13f 74a989083b'
      end

      it "parses out the author" do
        expect(subject.author).must_equal 'Dev1 <dev1@example.com>'
      end

      it "parses out the date" do
        expect(subject.date).must_equal 'Tue Sep 29 13:42:38 2020 +1000'
      end

      it "parses out the commit message" do
        expectation = <<~MESSAGE
        Merge pull request #4 from my/feature/branch
    
        fix: confusing wording.
        MESSAGE
        expect(subject.message).must_equal(expectation.rstrip)
      end
    end
  end
end
