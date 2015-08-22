#!/usr/bin/ruby
#
# just a simple XMPP notifier for hl and private messages
# Copyright (C) 2015  Sebastien Badia <seb@sebian.fr>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

SCRIPT_NAME = 'irc2xmpp'
SCRIPT_AUTHOR = 'Sebastien Badia <seb@sebian.fr>'
SCRIPT_DESC = 'Send highlights in channels to a jabber'
SCRIPT_VERSION = '0.1'
SCRIPT_LICENSE = 'GPL3'
JID = 'seb@sebian.fr'

def weechat_init
  Weechat.register SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", ""
  Weechat.hook_print("", "notify_message", "", 1, "normalhl", "")
  Weechat.hook_print("", "notify_private", "", 1, "private", "")
  return Weechat::WEECHAT_RC_OK
end

def normalhl( data, buffer, date, tags, visible, highlight, prefix, message )
  if highlight == "1"
    data = {}
    %w[ away type channel server ].each do |meta|
      data[ meta.to_sym ] = Weechat.buffer_get_string( buffer, "localvar_#{meta}" );
    end
    data[:away] = data[:away].empty? ? false : true
    if data[:type] == "channel"
      timestamp = Time.at(date.to_i).strftime("%H:%M")
      xmppmsg = "IRC highlight: (#{timestamp}) [<#{prefix}> on #{data[:channel]}] #{message.gsub(/'/, "_")}"
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
    xmppmsg = "IRC private: (#{timestamp}) [<#{prefix}> on #{data[:channel]}] #{message.gsub(/'/, "_")}"
    %x[echo '#{xmppmsg}' | /usr/bin/sendxmpp -t -r notifier #{JID}]
  end
  return Weechat::WEECHAT_RC_OK
end

#  vim: set ts=2 sw=2 tw=0 :
