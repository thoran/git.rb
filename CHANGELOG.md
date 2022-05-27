# CHANGELOG

## 0.14.0 (20220527) 
1. ~ README.md: /require 'Git'/require 'git.rb'/
2. ~ README.md: + #<> to a couple of commented out indications of output.
3. ~ git.rb.gemspec to include development dependencies.
4. + Gemfile
5. - lib/Array, as there's duplicate functionality in Ordinal.
6. - Thoran/Array, as there's duplicate functionality in Ordinal.
7. /Git.rb/git.rb/
8. ~ lib/Git/Branch.rb: + #<> to a commented out indications of output.
9. Ordinal 0.2.0 --> Ordinal 0.2.1
10. Swapped contents of lib/String/capture.rb and lib/Thoran/String/Capture/capture.rb.
11. test/Git.rb --> test/git_test.rb
12. ~ test/Git/Branch_test.rb: Use a fixture.
13. ~ test/Git/Remote_test.rb: Use a fixture.
14. ~ test/Git/Blame_test.rb: Dropped "git_" from the start of the fixture variable names.
15. ~ test/Git/Log_test.rb: Dropped "git_" from the start of the fixture variable names.
16. test/fixtures/git_blame_output.txt --> test/fixtures/blame_output.txt
17. test/fixtures/git_log_output.txt --> test/fixtures/log_output.txt

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
