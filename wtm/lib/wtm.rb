#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'
require 'json'
require 'uri'

program :name, 'wtm'
program :version, '0.0.1'
program :description, 'A commandline utility that provides tools for the conversion of web applications to their mobile counterparts'

command :build do |c|
  c.syntax = 'wtm build [options]'
  c.summary = 'This command builds the mobile application'
  c.description = 'This command builds the mobile application from the URL provided'
  c.example 'description', 'command example'
  c.option '--name NAME',String,'This option specifies the app name'
  c.option '--platform NAME',String,'This option specifies the platform to build to'
  c.option '--url URL',String,'This option specifies the URL of the web app'
  c.action do |args, options|
    if options.url =~ /\A#{URI::regexp(['http', 'https'])}\z/ and options.platform =~ /android/i 
      write_json options.name, options.url
      cmd = 'cd ' + File.expand_path('..') << '/Android/Web-to-mobile' << "&& ./gradlew assembleDebug && cp  #{File.expand_path('..')}/Android/Web-to-mobile/app/build/outputs/apk/app-debug.apk ~/Desktop"
      puts system(cmd)
    else
      puts "Specify an appropriate URL and platform (--platorm \'android\' currently supported)"
    end
  end
  
  def init_file
    dir = File.expand_path('..') << '/Android/Web-to-mobile/app/src/main/assets/init.json'
    f = File.new(dir,'r')
    json_string = ''
    
    f.each_line do |line|
      json_string << line
    end
    return json_string
  end
  
  def write_json(name,url)
    init_hash = JSON.parse(init_file)
    init_hash["AppName"] = name
    init_hash["URL"] = url
    File.open(File.expand_path('..') << '/Android/Web-to-mobile/app/src/main/assets/init.json','w'){|f| f.write JSON.generate init_hash}
  end
end

