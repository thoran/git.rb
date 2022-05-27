# git.rb
# Git

lib_dir = File.expand_path(File.join(__FILE__, '..'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'Git/Blame'
require 'Git/Branch'
require 'Git/Log'
require 'Git/Remote'
