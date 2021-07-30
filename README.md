# git.rb

## Description

Do git stuff from Ruby.

## Installation

Add this line to your application's Gemfile:

	gem 'git.rb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git.rb

## Usage

```ruby

require 'Git' # or require each sub-library separately as per below...

require 'Git/Blame'

git_blame = Git::Blame.new('file/in/git/repository.rb')
# => #<Git::Blame @filename='file/in/git/repository.rb'>

git_blame.entries
# => [#<Git::PorcelainEntry @porcelain_output='...', @line_number=1>, ...]

line_number = 123
git_blame_porcelain_entry = git_blame.find(line_number)
# => #<Git::PorcelainEntry @porcelain_output='...', @line_number=123>

git_blame_porcelain_entry.commit_hash
# => "c9ab2bce79441f15d0a37e2af68017e7680b7e8d"

git_blame_porcelain_entry.author
# => "thoran"

require 'Git/Branch'

Git::Branch.default
# => 'branch_name'

Git::Branch.local
# => Git::Branch

Git::Branch.remote
# => Git::Branch

Git::Branch.local.all, Git::Branch.all
# => [#<Git::Branch @name="master">, ...]

Git::Branch.remote.all
# => [#<Git::Branch @name="master">, ...]

Git::Branch.merged.all
# => [#<Git::Branch @name="master">, ...]

Git::Branch.remote.merged.all
# => [#<Git::Branch @name="master">, ...]

Git::Branch.current
# => #<Git::Branch @name="master">

Git::Branch.current.master?
# => true

git_branch = Git::Branch.new('branch_name')
# => #<Git::Branch @name="branch_name">

git_branch.merged?
# => true/false

git_branch.name, git_branch.to_s
# => 'branch_name'

git_branch = Git::Branch.new('branch_name', remote: 'remote_name')
# => #<Git::Branch @name="branch_name" @remote="remote_name">

git_branch.remote
# => "remote_name"

require 'Git/Log'

git_log = Git::Log.parse(`git log`)
# => [#<Git::Log @commits = [#<Git::Log::Commit @hash=..., @author="thoran", @date=..., @message=...>, ...]>

git_log.commits
# => [#<Git::Log::Commit @hash=..., @author="thoran", @date=..., @message=...>, ...]

git_log.commits.first
# => #<Git::Log::Commit @hash=..., @author="thoran", @date=..., @message=...>

git_log.commits.first.author
# => "thoran"

require 'Git/Remote'

Git::Remote.all
# => [#<Git::Remote @name='origin', @url='git@github.com:thoran/rails.git'>, #<Git::Remote @name='upstream', @url='git@github.com:rails/rails.git'>]

Git::Remote.exist?('origin')
# => true

git_remote = Git::Remote.find('origin')
# => #<Git::Remote @name='origin' @url='git@github.com:thoran/rails.git'>

git_remote.to_s
# => "origin git@github.com:thoran/rails.git"

git_remote.name
# => "origin"
```

## Contributing

1. Fork it ( https://github.com/thoran/git.rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request
