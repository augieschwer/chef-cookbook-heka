name		 "heka"
maintainer       "Augie Schwer"
maintainer_email "Augie@Schwer.us"
license          "Apache 2.0"
description      "Installs/Configures heka"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.2"

depends		 "logrotate"

%w{ debian ubuntu}.each do |os|
  supports os
end
