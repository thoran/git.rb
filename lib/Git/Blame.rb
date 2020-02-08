# Git/Blame.rb
# Git::Blame

# 20161115
# 0.2.0

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

      def initialize(porcelain_output)
        @porcelain_output = porcelain_output
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

    def entries
      line_count = 0
      porcelain_entry_string = ''
      entries = []
      `#{command_string}`.each_line do |porcelain_line|
        line_count +=1
        unless line_count.modulo(13).zero?
          porcelain_entry_string << porcelain_line
        else
          entries << PorcelainEntry.new(porcelain_entry_string).parse
          line_count = 0
          porcelain_entry_string = ''
        end
      end
      entries
    end

  end
end
