# Git/Remote.rb
# Git::Remote

# Examples:
#
# require 'Git/Remote'
#
# Git::Remote.all
# => [#<Git::Remote @name='origin', @url='git@github.com:thoran/rails.git'>, #<Git::Remote @name='upstream', @url='git@github.com:rails/rails.git'>]
#
# Git::Remote.exist?('origin')
# => true
#
# git_remote = Git::Remote.find('origin')
# => #<Git::Remote @name="origin" @url="git@github.com:thoran/rails.git">
#
# git_remote.to_s
# => "origin git@github.com:thoran/rails.git"
#
# git_remote.name
# => "origin"

module Git
  class Remote

    class << self

      def parse_line(remote_output_line)
        name, url = remote_output_line.split
        new(name: name, url: url)
      end

      def remote_output
        `git remote --verbose`
      end

      def all
        remote_output.split("\n").collect do |remote|
          parse_line(remote)
        end.uniq{|remote| remote.name}
      end

      def find(remote_name)
        all.detect{|remote| remote.name == remote_name}
      end

      def add_command(remote_name, remote_url)
        ['git remote add', remote_name, remote_url].join(' ')
      end

      def add(remote_name, remote_url)
        system add_command(remote_name, remote_url)
      end

      def remove_command(remote_name)
        ['git remote remove', remote_name].join(' ')
      end

      def remove(remote_name, remote_url)
        system remove_command(remote_name)
      end

      def exist?(remote_name)
        !!find(remote_name)
      end

    end # class << self

    attr_accessor :name
    attr_accessor :url

    def initialize(name:, url:)
      @name = name
      @url = url
    end

    def remove
      self.class.remove(@name, @url)
    end
    alias_method :delete, :remove

    def to_s
      "#{@name} #{@url}"
    end

  end
end
