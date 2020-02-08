# Git/Branch.rb
# Git::Branch

# Examples:
#
# Git::Branch.local, Git::Branch.all
# => [<Git::Branch @name='master'>, ...]
#
# Git::Branch.remote.all
# => [<Git::Branch @name='master'>, ...]
#
# Git::Branch.merged.all
# => [<Git::Branch @name='master'>, ...]
#
# Git::Branch.remote.merged.all
# => [<Git::Branch @name='master'>, ...]
#
# Git::Branch.current
# => <Git::Branch @name='master'>
#
# Git::Branch.current.master?
# => true

module Git
  class Branch

    @switches = []

    class << self

      def local; end

      def remote
        @switches << '--remote'
        self
      end

      def merged
        @switches << '--merged'
        self
      end

      def all
        command = ['git branch', @switches.join(' ')].join(' ').strip
        `#{command}`.split("\n").collect do |branch|
          branch_name = branch.sub('*', '').strip
          new(branch_name)
        end
      end

      def current
        branch_name = `git branch`.split("\n").detect{|branch| branch =~ /\*/}.sub('*', '').strip
        new(branch_name)
      end
      alias_method :head, :current

    end # class << self

    def initialize(name = nil)
      @name = name
    end

    def method_missing(method_name, *args, &block)
      if method_name =~ /\?$/
        @name == method_name.sub('?', '')
      end
    end

  end
end
