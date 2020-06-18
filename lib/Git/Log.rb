# Git/Log.rb
# Git::Log

# Examples:
#
# require 'Git/Log'
#
# git_log = Git::Log.parse(`git log`)
# => [#<Git::Log @commits = [#<Git::Log::Commit @hash=..., @author="thoran", @date=..., @message=...>, ...]>
#
# git_log.commits
# => [#<Git::Log::Commit @hash=..., @author="thoran", @date=..., @message=...>, ...]
#
# git_log.commits.first
# => #<Git::Log::Commit @hash=..., @author="thoran", @date=..., @message=...>
#
# git_log.commits.first.author
# => "thoran"

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

  end
end
