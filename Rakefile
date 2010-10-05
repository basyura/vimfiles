# -*- coding: utf-8 -*-

task :default => "all_update"

task :all_update => [:pull_vimfiles , :clone_github , :update_github] do
end

task :pull_vimfiles do
  puts "■ pull vimfiles ..."
  puts `git pull`
end

task :clone_github do
  puts "■ check github repositories ..."
  f = open("source.list" , "r")
  f.read.each_line do |line|
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
  puts "■ pull github repositories ..."
  Dir.chdir("gitplugins")
  Dir.glob("*") do |d|
    next unless File.directory? d
    Dir.chdir(d)
    puts "pull #{d} ..."
    puts `git pull`
    puts ""
    Dir.chdir("..")
  end
  Dir.chdir("..")
end
