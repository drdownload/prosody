
local st = require "util.stanza";

--local sessions = sessions;

local t_insert = table.insert;

local log = require "util.logger".init("mod_starttls");

local xmlns_starttls ='urn:ietf:params:xml:ns:xmpp-tls';

add_handler("c2s_unauthed", "starttls", xmlns_starttls,
		function (session, stanza)
			if session.conn.starttls then
				session.send(st.stanza("proceed", { xmlns = xmlns_starttls }));
				-- FIXME: I'm commenting the below, not sure why it was necessary
				-- sessions[session.conn] = nil;
				session:reset_stream();
				session.conn.starttls();
				session.log("info", "TLS negotiation started...");
			else
				-- FIXME: What reply?
				session.log("warn", "Attempt to start TLS, but TLS is not available on this connection");
			end
		end);
		
add_event_hook("stream-features", 
					function (session, features)												
						if session.conn.starttls then
							t_insert(features, "<starttls xmlns='"..xmlns_starttls.."'/>");
						end
					end);
