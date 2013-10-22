#!/usr/bin/ruby

SCRIPT_NAME = 'irc2xmpp'
SCRIPT_AUTHOR = 'Sebastien Badia <seb@sebian.fr>'
SCRIPT_DESC = 'Send highlights and private messages in channels to an Xmpp account'
SCRIPT_VERSION = '0.2'
SCRIPT_LICENSE = 'GPL3'

DEFAULTS = {
  'jid'         => "seb@sebian.fr",
  'interval'    => "60",
}

def weechat_init
  Weechat.register SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, "", ""
  DEFAULTS.each_pair { |option, def_value|
    cur_value = Weechat.config_get_plugin(option)
    if cur_value.nil? || cur_value.empty?
      Weechat.config_set_plugin(option, def_value)
    end
  }

  @last = Time.now - Weechat.config_get_plugin('interval').to_i

  Weechat.hook_signal("weechat_highlight", "notify", "")
  Weechat.hook_signal("weechat_pv", "notify", "")

  return Weechat::WEECHAT_RC_OK
end

def notify(data, signal, signal_data)

  @last = Time.now unless @last

  if signal == "weechat_pv"
    event = "Weechat Private message"
  elsif signal == "weechat_highlight"
    event = "Weechat Highlight"
  end

  if (Time.now - @last) > Weechat.config_get_plugin('interval').to_i
    %x[echo '#{event} (#{Time.now}) => #{signal_data}' /usr/bin/sendxmpp -t -r #{Weechat.config_get_plugin('jid')}]
    @last = Time.now
  else
    Weechat.print("", "irc2xmpp: Skipping notification, too soon since last notification")
  end

  return Weechat::WEECHAT_RC_OK
end

__END__
