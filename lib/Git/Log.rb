# Git::Log

# 20130304
# 0.0.0

require 'Ordinal/Array'

module Git
  class Log

    class Commit

      class << self
        def parse(commit_string)
          parsed_commit_string = commit_string.split("\n").collect{|line| line.strip}.select{|line| !line.empty?}
          Commit.new(
            hash: parsed_commit_string.first.gsub(/^commit /, ''),
            author: parsed_commit_string.second.gsub(/^Author: /, ''),
            date: parsed_commit_string.third.gsub(/^Date:   /, ''),
            message: parsed_commit_string.fourth
          )
        end
      end # class << self

      attr_reader :hash
      attr_reader :author
      attr_reader :date
      attr_reader :message

      def initialize(values = {})
        @hash = values[:hash]
        @author = values[:author]
        @date = values[:date]
        @message = values[:message]
      end

    end # class Commit

    @commits = []

    class << self

      attr_reader :commits

      def parse(log_stream)
        commit_log = Log.new
        commit_string = ''
        log_stream.each_line do |line|
          line.lstrip!
          if line =~ /^commit/ && !commit_string.empty?
            commit_log.prepend(Commit.parse(commit_string))
            commit_string = line
          else
            commit_string << line
          end
        end
        commit_log.prepend(Commit.parse(commit_string))
        commit_log
      end

    end # class << self

    attr_reader :commits

    def initialize(commits = [])
      @commits = commits
    end

    def prepend(commit_object)
      commits.unshift(commit_object)
    end
    alias_method :unshift, :prepend

    def method_missing(method_name, *args, &block)
      commits.send(method_name, *args, &block)
    end

  end # class Log
end # module Git

if __FILE__ == $0

  def test_git_log_commit
    commit_string = '
      commit ab550dc384cd9d49b1f1586ff957893988c04d22
      Author: thoran <code@thoran.com>
      Date:   Fri Nov 16 12:39:53 2012 +1100
      
          Commit #4.
    '
    commit = Git::Log::Commit.parse(commit_string)
    commit.hash == 'ab550dc384cd9d49b1f1586ff957893988c04d22' ? (print '.') : (print 'x')
    commit.message == 'Commit #4.' ? (print '.') : (print 'x')
  end

  def test_git_log
    log_stream = '
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
    '
    git_log = Git::Log.parse(log_stream)
    git_log.size == 4 ? (print '.') : (print 'x')
    git_log.first.hash == 'c39a4d62bd79969e3e9033a7573943b24cd81cd9' ? (print '.') : (print 'x')
  end

  def test
    test_git_log_commit
    test_git_log
    puts
  end

  test

end
