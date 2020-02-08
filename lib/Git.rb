# Git.rb
# Git

# 20200127, 0128, 0202, 0207, 0208
# 0.10.0

lib_dir = File.expand_path(File.join(__FILE__, '..'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Git/Blame'
require 'Git/Branch'
require 'Git/Log'
require 'Git/Remote'
