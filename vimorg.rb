require 'rubygems'
require 'yaml'
require 'mechanize'

VIMONLINE_SITE_PATH     = "http://www.vim.org/scripts/script.php?script_id="
VIMONLINE_DOWNLOAD_PATH = "http://www.vim.org/scripts/download_script.php?src_id="

Dir.chdir("plugins")
Dir.glob("*") do |d|
  next unless File.directory? d
  next unless File.exist? d + "/config.yaml"
  Dir.chdir(d)
  yaml = YAML.load_file("config.yaml")
  no = yaml["no"]
  
  proxy = ENV["http_proxy"].sub(/http:\/\// , "").split(":")
  agent = Mechanize.new
  agent.set_proxy(proxy[0] , proxy[1])

  src_id = nil
  agent.get(VIMONLINE_SITE_PATH + no.to_s).links.each do |link|
    unless link.href =~ /download_script.*?src_id=(.*?)$/
      next
    end
    break
  end
  src_id = $1
  if src_id
    puts `curl -o $TEMP/#{no}.zip #{VIMONLINE_DOWNLOAD_PATH}#{src_id}`
    puts `mkdir $TEMP/#{no}`
    puts `unzip -o $TEMP/#{no}.zip -d $TEMP/#{no}`
    puts "mv $TEMP/#{no}/* ."
    puts `cp -pr $TEMP/#{no}/* .`
  end
  Dir.chdir("..")
end

Dir.chdir("..")
