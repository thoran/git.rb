# Git/Blame.rb
# Git::Blame

# 20161115
# 0.0.0

require 'Array/all_but_first'

module Git
  class Blame

    class PorcelainEntry

      class << self

        def parse(porcelain_output)
          new(porcelain_output)
        end

      end # class << self

      def initialize(porcelain_output)
        @porcelain_output = porcelain_output
      end

      def commit_hash
        lines.first.split.first
      end

      def author
        @author ||= lines.detect{|line| line.split.first == 'author'}.split.all_but_first.join(' ')
      end

      def author_mail
        @author_mail ||= lines.detect{|line| line.split.first == 'author-mail'}.split.all_but_first.join(' ')
      end

      def author_time
        @author_time ||= lines.detect{|line| line.split.first == 'author-time'}.split.all_but_first.join(' ')
      end

      def author_tz
        @author_tz ||= lines.detect{|line| line.split.first == 'author-tz'}.split.all_but_first.join(' ')
      end

      def committer
        @committer ||= lines.detect{|line| line.split.first == 'committer'}.split.all_but_first.join(' ')
      end

      def committer_mail
        @committer_mail ||= lines.detect{|line| line.split.first == 'committer-mail'}.split.all_but_first.join(' ')
      end

      def committer_time
        @committer_time ||= lines.detect{|line| line.split.first == 'committer-time'}.split.all_but_first.join(' ')
      end

      def committer_tz
        @committer_tz ||= lines.detect{|line| line.split.first == 'committer-tz'}.split.all_but_first.join(' ')
      end

      def summary
        @summary ||= lines.detect{|line| line.split.first == 'summary'}.split.all_but_first.join(' ')
      end

      def previous
        @previous ||= lines.detect{|line| line.split.first == 'previous'}.split.all_but_first.join(' ')
      end

      def filename
        @filename ||= lines.detect{|line| line.split.first == 'filename'}.split.all_but_first.join(' ')
      end

      private

      def lines
        @lines ||= @porcelain_output.split("\n")
      end

    end # class PorcelainEntry

    def command_string(filename, line_number)
      "git blame -L #{line_number},#{line_number} #{filename} --line-porcelain"
    end

  end
end
