#!/usr/bin/ruby -w
# listToconf - Convert list of mac to dhcp conf.
# 2010 Sebastien Badia <seb@sebian.fr>
# Grid5000 - Nancy
#
# (mac-fich) head mac-graphene.txt
# 00:E0:81:D5:06:83
# 00:E0:81:D5:07:73

mac=ARGV[0]
cluster=ARGV[1]
site=ARGV[2]
ipone=ARGV[3]
i = 1

if ARGV.length <4
	puts "Erreur arguments\n\nUsage: listToconf.rb <mac-fich> <cluster-name> <site-name> <ip-one> <ipmi>\n\nExemple:listToconf.rb mac.txt griffon nancy 172.28.54\n\tlistToconf.rb mac.txt griffon nancy 172.28.154 ipmi\n\n"
	exit(0)
end

conf = File.open("dhcp-#{ARGV[1]}.conf",'w')
if File.file?(mac)&&File.writable?(mac)
	puts "Traitement"
	File.open(mac,'r') do |file|
		file.each_line do |line|
			if ARGV[4]
				conf.write "host #{cluster}-#{i}-bmc.#{site}.grid5000.fr {\n"
			else
				conf.write "host #{cluster}-#{i}.#{site}.grid5000.fr {\n"
			end
			conf.write "  hardware ethernet\t" + line.match(/([a-fA-F0-9]{2}:){5}([a-fA-F0-9]{2})/).to_s + ";" + "\n"
			conf.write "  fixed-address\t\t#{ipone}.#{i};\n"
			if ARGV[4]
				conf.write "  option host-name\t\"#{cluster}-#{i}-bmc\";\n}\n\n"
			else
				conf.write "  option host-name\t\"#{cluster}-#{i}\";\n}\n\n"
			end
			i += 1
			#puts "Node #{cluster}-#{i} Ok"
		end
	end
	puts "Ok"
end
