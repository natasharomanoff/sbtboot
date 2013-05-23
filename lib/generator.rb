require 'fileutils'

module SbtBoot

	class Generator
		attr_accessor :name, :package, :project


		def expand(template, output)
			@project.create_package(@package)

			erb = ERB.new(File.read(@project.rel_templates(template)))
			destination =  Utils.source_path(output, @package)
			File.write( @project.rel_root(destination), erb.result(binding) )
		end
	end
end