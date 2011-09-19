namespace :applet do
  namespace :dev do
    desc "Symlinks the applet into $squeezeplay_path applet dir"
    task :ln do
      if File.exists?(Applet.squeezeplay_applet_dir)
        puts "Already symlinked"
      else
        ln_s File.expand_path("./applet"), Applet.squeezeplay_applet_dir
      end
    end
  end

  desc "SCP applet to controller"
  task :install do
    if ENV["device"].nil? || ENV["device"].empty?
      raise "Usage: rake applet:install device=HOSTNAME_OF_SQUEEZEPLAY_DEVICE"
    end
    puts %x[scp -r -v #{Applet::DIR}/* root@#{ENV['device']}:/usr/share/jive/applets/#{Applet.name}]
  end
end

module Applet
  DIR = File.expand_path(File.join(File.dirname(__FILE__), "applet"))
  
  class << self
    # squeezeplay convention is to name the meta/applet files
    # $APPLET_NAMEmeta.lua etc.
    def name
      File.basename(Dir["#{DIR}/*Meta.lua"].first).split("Meta").first
    end

    def squeezeplay_applet_dir
      if ENV["squeezeplay_path"].nil? || ENV["squeezeplay_path"].empty?
        raise "Usage: rake applet:dev:ln squeezeplay_path=PATH_TO_YOUR_SQUEEZEPLAY"
      end
      File.join(ENV["squeezeplay_path"], "share", "jive", "applets", Applet.name)
    end
  end
end
