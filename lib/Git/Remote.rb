# Git/Remote.rb
# Git::Remote

# Examples:
#
# Git::Remote.all
# => [<Git::Remote @name='origin'>, ...]
#
# git_remote = Git::Remote.all.first.to_s
# => "origin"

module Git
  class Remote

    class << self

      def all
        command = ['git remote'].join(' ')
        `#{command}`.split("\n").collect do |remote_name|
          remote_name = remote_name.strip
          new(remote_name)
        end
      end

    end # class << self

    attr_accessor :name

    def initialize(name = nil)
      @name = name
    end

    def to_s
      @name
    end

  end
end
