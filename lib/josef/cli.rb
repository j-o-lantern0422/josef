module Josef
  class Cli < Thor
    class_option :dry_run, :type => :boolean, :default => false

    desc "dump", "dump google workspace group"
    def dump
      puts "yo"
    end
  end
end
