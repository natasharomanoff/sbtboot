module SbtBoot

  class Utils
    def self.package2path(s)
    	File.join(s.split('.'))
    end

    def self.source_path(name, package, type=:scala)
    	File.join("src/main", type.to_s, package2path(package), name)
    end

    def self.isSbtRoot?()
    	File.exists?(File.join(Dir.pwd, 'build.sbt'))
    end

  end

end