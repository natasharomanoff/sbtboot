module SbtBoot

  class Dependency
  	DEPS = {
  		:akka   =>  { 
  			     		:resolver => ["Typesafe Repository", "http://repo.typesafe.com/typesafe/releases/"], 
  			        	:libdeps  => ["com.typesafe.akka" , "akka-actor" , "2.1.4"]
  			        },
  		
  		:specs2 =>  { 
  			        	:resolver => ["Sonatype Repository", "http://oss.sonatype.org/content/repositories/releases"], 
  			           	:libdeps  => ["org.specs2", "specs2", "1.12.3", "test"]
  			        },
  		
  		:finagle => { 
  						:resolver => [], 
  			       		:libdeps => ["com.twitter", "finagle-http", "6.2.0"]
  			        },
  		
  		:scalaz => { 
  						:resolver => [], 
  			       		:libdeps  => ["org.scalaz", "scalaz-core", "7.0.0"]
  			       }

  	}  	

  	def self.resolver(s)
  		DEPS[s][:resolver]
  	end

  	def self.libdeps(s)
  		DEPS[s][:libdeps]
  	end

  	def self.all_resolvers(lst)
  		lst.map {|d| Dependency.resolver(d.to_sym)}.sort.uniq.select { |e| !e.empty? }
  	end

  	def self.all_libdeps(lst)
  		lst.map {|d| Dependency.libdeps(d.to_sym)}.sort.uniq.select { |e| !e.empty? }
  	end

  end

end