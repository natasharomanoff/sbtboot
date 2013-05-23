require "sbtboot/version"
require 'thor'
require 'sbt_project'
require 'pp'
require 'dependency'
require 'utils'
require 'generator'

class String 

	def camelize()
		split(/[-_ ]/).collect{ |e| e.capitalize }.join
	end

	def packagize()
		split(/[-_ ]/).collect{ |e| e.downcase }.join('.')
	end
end

module SbtBoot

  class SbtBoot < Thor

	desc "project NAME [PACKAGE]", "Create a simple scala project skeleton"
  	method_option :version, :type => :string, :default => '1.0', :aliases => :v
  	method_option :scala_version, :type => :string, :default => '2.10.1', :aliases => :sv
	method_option :"deps",  :type => :array, :default => []
	def project(name, package=name.packagize)
		project = SBTProject.new do |p|
			p.name = name
			p.version = options[:version]
			p.scala_version = options[:scala_version]
			p.package = package
			p.resolvers = Dependency.all_resolvers(options[:deps])

			p.lib_deps  = Dependency.all_libdeps(options[:deps])
		end
		project.create_base
		project.expand_main('hello.scala.erb')
	end

	
	desc "akka_actor NAME [PACKAGE]", "Create an Akka Actor skeleton"
	def akka_actor(name, package="")
		if Utils.isSbtRoot?
			p = SBTProject.parse
			g = Generator.new
			g.name= name
			g.project = p
			g.package = package
			g.expand("akka_actor.scala.erb", "#{name.camelize}.scala")
		else
			puts "Not a sbt project"
		end
	end

	desc "finagle NAME [PACKAGE]", "Create a Finagle Server skeleton"
	def finagle(name, package=name.packagize)
		if Utils.isSbtRoot?
			p = SBTProject.parse
			g = Generator.new
			g.name= name
			g.project = p
			g.package = package
			g.expand("finagle_server.scala.erb", "#{name.camelize}.scala")
		else
			puts "Not a sbt project"
		end
	end

  end
end
