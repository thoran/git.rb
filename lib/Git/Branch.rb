# Git/Branch.rb
# Git::Branch

# Examples:
#
# require 'Git/Branch'
#
# Git::Branch.local
# => #<Git::Branch>
#
# Git::Branch.local.all, Git::Branch.all
# => [#<Git::Branch @name="master">, ...]
#
# Git::Branch.remote.all
# => [#<Git::Branch @name="master">, ...]
#
# Git::Branch.merged.all
# => [#<Git::Branch @name="master">, ...]
#
# Git::Branch.remote.merged.all
# => [#<Git::Branch @name="master">, ...]
#
# Git::Branch.current
# => #<Git::Branch @name="master">
#
# Git::Branch.current.master?
# => true
#
# git_branch = Git::Branch.new('branch_name')
# => #<Git::Branch @name="branch_name">
#
# git_branch.merged?
# => true/false
#
# git_branch.name, git_branch.to_s
# => "branch_name"
#
# git_branch = Git::Branch.new('branch_name', remote: 'remote_name')
# => #<Git::Branch @name="branch_name" @remote="remote_name">
#
# git_branch.remote
# => "remote_name"

require 'Array/all_but_first'

module Git
  class Branch

    @switches = []

    class << self

      def local
        self
      end

      def remote
        @switches << '--remote'
        self
      end

      def merged
        @switches << '--merged'
        self
      end

      def command_string
        command_string = ['git branch', @switches.join(' ')].join(' ').strip
        @switches = []
        command_string
      end

      def branch_output
        `#{command_string}`
      end

      # Whether --remote was asked for is read before branch_output, whose command_string clears the switches. A remote's HEAD, as origin/HEAD -> origin/master, names another branch and is left out.
      def all
        remote_branches = @switches.include?('--remote')
        branch_output.split("\n").reject{|branch| branch.include?(' -> ')}.collect do |branch|
          if remote_branches
            branch_parts = branch.split('/')
            remote_name, branch_name = branch_parts.first.sub('*', '').strip, branch_parts.all_but_first.join('/')
            new(branch_name, remote: remote_name)
          else
            branch_name = branch.sub('*', '').strip
            new(branch_name)
          end
        end
      end

      def current
        branch_name = branch_output.split("\n").detect{|branch| branch =~ /\*/}.sub('*', '').strip
        new(branch_name)
      end
      alias_method :head, :current

      def default
        `git rev-parse --abbrev-ref origin/HEAD`.strip.split('/').last
      end

    end # class << self

    attr_accessor :name
    attr_accessor :remote

    def initialize(name = nil, **args)
      @name = name
      @remote = args[:remote]
    end

    def merged?
      if @remote
        self.class.remote.merged.all.collect{|branch| branch.to_s}.include?(to_s)
      else
        self.class.merged.all.collect{|branch| branch.name}.include?(@name)
      end
    end

    def to_s
      if @remote
        @remote + '/' + @name
      else
        @name
      end
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s =~ /\?$/ && !self.class.instance_methods.include?(method_name)
        @name == method_name.to_s.sub('?', '')
      end
    end

  end
end
