# -*- coding: utf-8 -*-

require 'fileutils'

task :default => "all_update"

task :all_update => [:pull_vimfiles , :clone_github , :update_github] do
end

task :pull_vimfiles do
  puts ""
  puts ">>> pull vimfiles ..."
  puts `git pull`
end

task :clone_github do
  puts ""
  puts ">>> check github repositories ..."
  f = open("source.list" , "r")
  f.read.each_line do |line|
    next if line =~ /^#/
    line.chomp!
    path = "./gitplugins/#{line.split(/\//)[-1]}".sub(/\.git/ , "")
    if File.exist?(path)
      puts "#{path} ... ok"
    else
      puts "#{path} ... no"
      Dir.chdir("gitplugins")
      `git clone #{line}`
      Dir.chdir("..")
    end
  end
  f.close
end

task :update_github do
  puts ""
  puts ">>> pull github repositories ..."
  Dir.chdir("gitplugins")
  Dir.glob("*") do |d|
    next unless File.directory? d
    Dir.chdir(d)
    puts ""
    puts "pull #{d} ..."
    puts `git pull`
    Dir.chdir("..")
  end
  Dir.chdir("..")
end

# cygwin の home になってしまう
task :clear_cache do
  puts ">>> clear neocomplcache's cache"
  Dir.chdir(ENV["HOME"] + "/.neocon/")
  list = Dir.glob("**/*")
  puts "cd #{Dir.pwd}"
  puts list
  FileUtils.rm(list , {:force => true})
end
