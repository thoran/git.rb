# Git/Branch.rb
# Git::Branch

# Examples:
#
# Git::Branch.all
# => ['master', ...]
#
# Git::Branch.current
# => 'master'

module Git
  class Branch

    class << self

      def all
        `git branch`.split("\n").collect{|branch| branch.sub('*', '').strip}
      end

      def current
        `git branch`.split("\n").detect{|branch| branch =~ /\*/}.sub('*', '').strip
      end

    end # class << self

  end
end
