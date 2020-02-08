# Git/Blame.rb
# Git::Blame

# Examples:
#
# require 'Git/Blame'
#
# git_blame = Git::Blame.new('file/in/git/repository.rb')
# => #<Git::Blame @filename='file/in/git/repository.rb'>
#
# git_blame.entries
# => [#<Git::PorcelainEntry @porcelain_output='...', @line_number=1>, ...]
#
# line_number = 123
# git_blame_porcelain_entry = git_blame.find(line_number)
# => #<Git::PorcelainEntry @porcelain_output='...', @line_number=123>
#
# git_blame_porcelain_entry.commit_hash
# => "c9ab2bce79441f15d0a37e2af68017e7680b7e8d"
#
# git_blame_porcelain_entry.author
# => "thoran"

require 'Array/all_but_first'
require 'Array/all_but_last'

module Git
  class Blame

    class PorcelainEntry

      class << self

        def parse(porcelain_output)
          new(porcelain_output).parse
        end

      end # class << self

      attr_reader :line_number

      def initialize(porcelain_output, line_number = nil)
        @porcelain_output = porcelain_output
        @line_number = line_number
      end

      def parse
        lines_with_keys.each do |line|
          variable_name = line.split.first.tr('-','_')
          value = line.split.all_but_first.join(' ')
          instance_variable_set("@#{variable_name}", value)
          self.class.class_eval("attr_reader :#{variable_name}")
        end
        self
      end

      def commit_hash
        lines.first.split.first
      end

      def previous_commit_hash
        @previous.split.first
      end

      def code
        lines.last
      end

      private

      def lines
        @lines ||= @porcelain_output.split("\n")
      end

      def lines_with_keys
        @lines_with_keys ||= lines.all_but_first.all_but_last
      end

    end # class PorcelainEntry

    def initialize(filename, line_number = nil)
      @filename = filename
      @line_number = line_number
    end

    def command_string
      if @line_number
        "git --no-pager blame -L #{@line_number},#{@line_number} #{@filename} --line-porcelain"
      else
        "git --no-pager blame #{@filename} --line-porcelain"
      end
    end

    def blame_output
      `#{command_string}`
    end

    def entries
      line_count = 0
      porcelain_entry_string = ''
      entries = []
      blame_array = blame_output.split("\n")
      line_number = 0
      i = -1
      until i >= blame_array.size - 1
        until blame_array[i].split.first == 'filename'
          porcelain_entry_string << blame_array[i += 1]
          porcelain_entry_string << "\n"
        end
        porcelain_entry_string << blame_array[i += 1]
        porcelain_entry_string << "\n"
        entries << PorcelainEntry.new(porcelain_entry_string, line_number += 1).parse
        line_count = 0
        porcelain_entry_string = ''
      end
      entries
    end

    def find(line_number)
      @line_number = line_number
      entries.detect{|entry| entry.line_number == @line_number}
    end

  end
end
