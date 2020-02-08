# Git/Remote.rb
# Git::Remote

# Examples:
#
# Git::Remote.all
# => [<Git::Remote @name='origin'>, ...]
#
# Git::Remote.exist?('origin')
# => <Git::Remote @name='origin' @url=...>
#
# git_remote = Git::Remote.all.first.to_s
# => "origin"

module Git
  class Remote

    class << self

      def all
        command = 'git remote --verbose'
        `#{command}`.split("\n").collect do |remote|
          new_from_command_output(remote)
        end.uniq{|remote| remote.name}
      end

      def find(remote_name)
        all.detect{|remote| remote.name == remote_name}
      end

      def add(remote_name, remote_url)
        command = ['git remote add', remote_name, remote_url].join(' ')
        system command
      end

      def remove(remote_name, remote_url)
        command = ['git remote remove', remote_name].join(' ')
        system command
      end

      def exist?(remote_name)
        !!find(remote_name)
      end

      private

      def new_from_command_output(remote)
        name, url = remote.split
        new(name: name, url: url)
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
