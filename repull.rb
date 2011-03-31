#!/usr/bin/ruby -w

dev = "/home/sbadia/dev"
verbose = false

puts "[Update #{dev} repo]"
repo = Dir.entries(dev)
repo.sort
Dir.chdir(dev)
if (verbose == true) then
	puts "Répertoire "+Dir.pwd
end
for g in (0..repo.length-1)
	if (File.directory?(repo[g]) == true) then
		Dir.chdir(repo[g])
		if (File.directory?(".svn") == true) then
			if (verbose == true) then
				puts "Versioning SVN"
			end
			puts "### Update "+repo[g]
			system("svn update")
		elsif (File.directory?(".git") == true) then
			if (verbose == true) then
				puts "Versioning GIT"
			end
			puts "*** Update "+repo[g]
			system("git pull")
		elsif (File.directory?(".hg") == true) then
			if (verbose == true) then
				puts "Versioning Mercurial"
			end
			puts "%%% Update "+repo[g]
			system("hg pull")
		else
			if (verbose == true) then
				puts "Not supported yet"
			end
		end
		Dir.chdir(dev)
	else
		if (verbose == true) then
			puts "File "+repo[g]
		end
	end
end
if (verbose == true) then
	puts "Répertoire "+Dir.pwd
end
puts "[Update #{dev} Done !]"
