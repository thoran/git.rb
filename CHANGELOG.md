# CHANGELOG

## 0.13.0 (20210730)
1. ~ README.md to include refrence to Git::Branch.default
2. ~ README.md to include refrence to Git::Branch.remote

## 0.13.0 (20210702): ~ Git::Blame#find retains all porcelain entries being able to be found
1. ~ Git::Blame#find, so that it doesn't assign @line_number, thereby retaining access to all porcelain entries
2. /CHANGES.txt/CHANGELOG.md/, ascending --> descending date order

## 0.12.0 (20201022)
1. + Git::Branch.default
2. + Git::Branch#method_missing tests

## 0.11.0 (20201008)
1. ~ Git::Log::Commit.parse: completely rewritten, so as to be able to handle merge commits as well as non-merge commits which have a slightly different format.
2. ~ Git/Log_test.rb, so as to cover merge commits for both Git::Log::Commit and Git::Log.
3. + String#capture (Thoran::String::Capture#capture)

## 0.10.4 (20200619)
1. ~ ./git.rb.gemspec with the right date.

## 0.10.3 (20200618)
1. ~ Git::Log.parse: lstrip!'ing each line causes issues in that edge case there a commit message has "   commit" at the start of the line.

## 0.10.2 (20200401, 0618)
1. ~ lib/Git/VERSION.rb (0.10.0 --> 0.10.2!)
2. ~ git.rb.gemspec: + require_relative './lib/Git/VERSION'

## 0.10.1 (20200330)
1. lib/Thoran/* --> lib/Thoran/Array (It was working only because I had these files in the Ruby library path elsewhere.)

## 0.10.0 (20200208): Preparation for release as a gem
1. + dependencies, including those in lib/Array and lib/Ordinal, and hence lib/Thoran.
2. Now using $LOAD_PATH manipulation instead of require_relative.
3. + test (Either moved out of class implementations or created.)
4. + .gitignore
5. + CHANGES.txt
6. + git.rb.gemspec
7. + lib/Git/VERSION.rb
8. + README.md
9. + TODO.txt
