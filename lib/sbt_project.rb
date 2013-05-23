require 'fileutils'
require 'erb'
require 'utils'

module SbtBoot
	
	class SBTProject

		attr_accessor :name, :version, :scala_version, :package, :resolvers, :lib_deps

		def initialize
			@resolvers = []
			@lib_deps = []
			yield self if block_given?
		end

		def root()
			if Utils.isSbtRoot?
				Dir.pwd
			else
				File.join(Dir.pwd, @name)
			end
		end

		def rel_root(p)
			File.join(root(), p)
		end

		def rel_templates(p)
			File.join(File.dirname(__FILE__), '..','templates', p)
		end

		def create_dir_structure
			[:scala, :java, :resources].each do |f|
				FileUtils.mkdir_p(rel_root("src/main/#{f.to_s}"))
				FileUtils.mkdir_p(rel_root("src/test/#{f.to_s}"))
			end
			FileUtils.mkdir_p(rel_root('project'))
			FileUtils.mkdir_p(rel_root("src/main/scala/#{Utils.package2path(package)}"))
		end

		def touch(rpath)
			FileUtils.touch(rel_root(rpath))
		end

		def expand(s,d)
			erb = ERB.new(File.read(rel_templates(s)))
			File.write( rel_root(d), erb.result(binding))
		end

		def tcopy(s,d)
			FileUtils.copy(rel_templates(s), rel_root(d))
		end

		def create_base
			create_dir_structure
			touch(  'project/Build.scala')
			expand( 'build.sbt.erb', 'build.sbt')
			expand( 'plugins.sbt.erb', 'project/plugins.sbt')
			tcopy(  'gitignore', '.gitignore')
		end

		def expand_main(template, type=:scala)
			expand(template, Utils.source_path("#{@name.camelize}.#{type.to_s}", @package, type))
		end

		def create_package(p)
			pkg_dir = File.join('src/main/scala', Utils.package2path(p))
			abs_pkg_dir = rel_root(pkg_dir)
			FileUtils.mkdir_p(abs_pkg_dir) if !Dir.exists?(abs_pkg_dir)
		end



		def self.parse
			 lines = File.readlines(File.join(Dir.pwd, 'build.sbt')).collect{ |l| l.strip}.select{ |l| !l.empty? }
			 props = Hash[*(lines.select{ |l| l.match /:=/ }.collect{|l| l.split(':=') }.flatten.collect { |e| e.strip.gsub(/"/, "") })]

			project = SBTProject.new do |p|
				p.name          = props['name']
				p.version       = props['version']
				p.scala_version = props['scalaVersion']
			end

		end
	end

end
