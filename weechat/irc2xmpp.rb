#!/usr/bin/ruby
#
# ~/.weechat/ruby/autoload/irc2xmpp.rb
# Need sendxmpp (configured).

SCRIPT_NAME = 'irc2xmpp'
SCRIPT_AUTHOR = 'Sebastien Badia <seb@sebian.fr>'
SCRIPT_DESC = 'Send IRC highlights to a jabber jid (using sendxmpp)'
SCRIPT_VERSION = '0.1'
SCRIPT_LICENSE = 'GPL3'
JID = 'seb@sebian.fr'

def weechat_init
  Weechat.register SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", ""
	Weechat.hook_print("", "notify_message", "", 1, "irc2xmpp", "")
  Weechat.hook_print("", "notify_private", "", 1, "private", "")
	return Weechat::WEECHAT_RC_OK
end

def irc2xmpp( data, buffer, date, tags, visible, highlight, prefix, message )
	if highlight == "1"
		data = {}
		%w[ away type channel server ].each do |meta|
			data[ meta.to_sym ] = Weechat.buffer_get_string( buffer, "localvar_#{meta}" );
		end
		data[:away] = data[:away].empty? ? false : true
		if data[:type] == "channel"
			timestamp = Time.at(date.to_i).strftime("%H:%M")
			xmppmsg = "IRC highlight: (#{timestamp}) [<#{prefix}> on #{data[:channel]}] #{message}"
      %x[echo '#{xmppmsg}' | /usr/bin/sendxmpp -t -r notifier #{JID}]
		end
	end
	return Weechat::WEECHAT_RC_OK
end

def private( data, buffer, date, tags, visible, highlight, prefix, message )
	data = {}
	%w[ away type channel server ].each do |meta|
		data[ meta.to_sym ] = Weechat.buffer_get_string( buffer, "localvar_#{meta}" );
	end
	data[:away] = data[:away].empty? ? false : true
	unless data[:channel] == data[:server]
		timestamp = Time.at(date.to_i).strftime("%H:%M")
		xmppmsg = "IRC private: (#{timestamp}) [<#{prefix}> on #{data[:channel]}] #{message}"
    %x[echo '#{xmppmsg}' | /usr/bin/sendxmpp -t -r notifier #{JID}]
	end
	return Weechat::WEECHAT_RC_OK
end
#  vim: set ts=2 sw=2 tw=80 :
