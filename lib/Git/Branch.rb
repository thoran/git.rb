# Git/Branch.rb
# Git::Branch

# Examples:
#
# Git::Branch.all
# => [<Git::Branch @name='master'>, ...]
#
# Git::Branch.current
# => <Git::Branch @name='master'>
#
# Git::Branch.current.master?
# => true

module Git
  class Branch

    class << self

      def all
        `git branch`.split("\n").collect do |branch|
          branch_name = branch.sub('*', '').strip
          new(branch_name)
        end
      end

      def current
        branch_name = `git branch`.split("\n").detect{|branch| branch =~ /\*/}.sub('*', '').strip
        new(branch_name)
      end

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
