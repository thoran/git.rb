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
require 'String/capture'

module Git
  class Log

    class Commit

      class << self
        def parse(commit_string)
          hash = merge = author = date = message = ''
          commit_string.split("\n").each do |line|
            case line.strip
            when /^commit (\w+)/
              hash = line.strip.capture(/^commit (\w+)/)
            when /^Merge: /
              merge = line.strip.gsub(/^Merge: /, '')
            when /^Author: /
              author = line.strip.gsub(/^Author: /, '')
            when /^Date:   /
              date = line.strip.gsub(/^Date:   /, '')
            else
              if line.strip.empty?
                (message ||= '') << "\n\n"
              else
                (message ||= '') << line.lstrip
              end
            end
          end
          commit_args = {
            hash: hash,
            author: author,
            date: date,
            message: message.lstrip
          }
          commit_args.merge!(merge: merge)
          Commit.new(commit_args)
        end
      end # class << self

      attr_reader :hash
      attr_reader :merge
      attr_reader :author
      attr_reader :date
      attr_reader :message

      def initialize(values = {})
        @hash = values[:hash]
        @merge = values[:merge]
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
