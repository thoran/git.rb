# git.rb/CHANGELOG

## 0.15.1 (20261005): + the test fixtures to spec.files, so that the shipped suite can run
1. ~ git.rb.gemspec: + `Dir['test/fixtures/*.txt']` to spec.files. 0.14.2 added `Dir['test/**/*.rb']` meaning to ship the tests, while the four fixtures they read stayed unshipped, so the suite in the gem could not run at all. Built with them in, every test loads and finds its fixture. spec.files now reads the gemspec first, then the globs, then the single files alphabetically, the same 33 files either way.
2. ~ test/Git/Blame_test.rb, test/Git/Branch_test.rb, test/Git/Remote_test.rb: + `require 'minitest/mock'`, without which #stub was undefined and 14 tests across the three files errored rather than ran. 21 assertions had never executed. The fixtures are what make this reach beyond this repository: with both, the suite is green from an unpacked gem.
3. ~ CHANGELOG.md: reworded 0.15.0's item 2, which argued the minor from the breakage, by way of platforms and shims and what a patch may not do, where the reason is just that the load file's case changed and the load file is interface.
4. ~ Git::VERSION: /0.15.0/0.15.1/

## 0.15.0 (20261006): lib/Git.rb --> lib/git.rb, so that `require 'git.rb'` resolves on a case-sensitive filesystem
1. lib/Git.rb --> lib/git.rb: the gem is git.rb and the README has said `require 'git.rb'` since 0.14.0, while the file answering it stayed capitalised, so that require raised LoadError anywhere but a case-insensitive filesystem. 0.14.0's item 7, /Git.rb/git.rb/, was the project and not the load file, which is how this sat unnoticed across four releases.
2. The minor and not the patch: the load file's case has changed, and the load file is interface. No compatibility shim was possible either way, since lib/Git.rb reduced to `require_relative 'git'` cannot be checked out beside lib/git.rb on APFS.
3. + test/loading_test.rb: that lib/ carries the lowercase name, and that requiring the gem by name in a fresh process defines Git and Git::VERSION. Dir.entries reports the name as stored, which is how a case-insensitive filesystem is asked the question a case-sensitive one would ask.
4. ~ test/Git/VERSION_test.rb: /require 'Git'/require 'git.rb'/
5. ~ git.rb.gemspec: spec.date /2023-06-28/2026-10-06/
6. ~ CHANGELOG.md: /# CHANGELOG/# git.rb\/CHANGELOG/, and dropped a trailing space from the 0.14.0 heading.
7. ~ Git::VERSION: /0.14.3/0.15.0/

## 0.14.3 (20260910): ~ lib/Git.rb: + require 'Git/VERSION'; + test/Git/VERSION_test.rb
1. ~ lib/Git.rb: + `require 'Git/VERSION'`, last among the requires. The file has been present and unreached, so `require 'git.rb'` left Git::VERSION undefined and the gemspec was the only thing loading it.
2. + test/Git/VERSION_test.rb: that Git::VERSION is a string, that it is three numbers separated by dots, and that it matches the newest entry in the changelog. Modelled on moby's, which is where the convention comes from.
3. The test loads the library rather than VERSION.rb, which is the whole of its value: run against v0.14.2 it fails with "uninitialized constant Git::VERSION". Nine libraries were in that state and not one of them carried this test, which is how it went unseen.
4. ~ Git::VERSION: /0.14.2/0.14.3/

## 0.14.2 (20260822): + LICENSE, which the gemspec has claimed without one being present.
1. + LICENSE: the MIT text, copyright 2020-2026 thoran. The gemspec has declared MIT while the repository carried no licence text at all.
2. ~ git.rb.gemspec: spec.files was Dir['lib/**/*.rb'] alone, so CHANGELOG.md, Gemfile, LICENSE, README.md, TODO.txt, the gemspec itself and the tests all went unshipped. Now an explicit list.
3. ~ README.md: + License
4. ~ Git::VERSION: /0.14.1/0.14.2/

## 0.14.1 (20230628): Fix missing dependencies.
1. + lib/Array/all_but_first.rb
2. + lib/Array/all_but_last.rb
3. + lib/Thoran/Array/AllButFirst/all_but_first.rb
4. + lib/Thoran/Array/AllButLast/all_but_last.rb
5. + lib/Thoran/Array/FirstX/firstX.rb
6. + lib/Thoran/Array/LastX/lastX.rb

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
18. ~ README.md to include reference to Git::Branch.default
19. ~ README.md to include reference to Git::Branch.remote

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
