puppet-nxlog
============

This module installs nxlog and makes sure it is running, it will also
dynamically try to look up any IIS websites currently running on the host where
it is applied.

## Parsing of Site Names

If you format your site name with this standard:

`MyApp v1.2.3 Special Suace`

You will get nice fields in Kibana/LogStash for it. See templates/nxing.conf.erb
and the regex there.

