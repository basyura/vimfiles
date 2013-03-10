# -*- coding: utf-8 -*-

require 'fileutils'
require 'thread'

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

  que = Queue.new
  Dir.glob("*") do |d|
    que.push d
  end

  dir = Dir.pwd

  threads = []
 
  while !que.empty?
    threads << Thread.new(que.pop) do |target|
      repos  =  File.join(dir, target)
      if File.directory? repos
        Dir.chdir(repos)
        #puts "git pull #{target}"
        ret = `git pull 2>&1`
        if ret.chomp != 'Already up-to-date.'
          error_flg = false
          ret.each_line do |line|
            if line =~ /error/
              puts "#{target} ... #{line}"
              error_flg = true
              break
            end
          end
          puts "updated #{target}" unless error_flg
        end
      end
    end
  end
  threads.each do |t|
    t.join
  end
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
