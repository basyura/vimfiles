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
    unless File.exist?(path)
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
    print "  pull #{d} ...".ljust(50)
    print "\r"
    ret = `git pull 2>&1`
    if ret.chomp == 'Already up-to-date.'
      STDOUT.flush
      print "  pull #{d} ... ok".ljust(80) + "\r"
      sleep 0.5
      STDOUT.flush
    else
      error_flg = false
      ret.each_line do |line|
        if line =~ /error/
          puts "#{d} ... #{line}"
          error_flg = true
          break
        end
      end
      #if line.split("\n") != 1
        #puts "#{d}"
        #puts line
      #elsif !error_flg
        #print "#{d} was Updated\n"
      #end
      print "updated #{d}\n" unless error_flg
    end
    Dir.chdir("..")
  end
  Dir.chdir("..")
  puts "".ljust(80)
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
