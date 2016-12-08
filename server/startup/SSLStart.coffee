###
Meteor.startup ->
	SSLProxy
		port: process.env.PORT, 
		ssl : {
			key: Assets.getText("ssl/key.pem"),
			cert: Assets.getText("ssl/cert.pem"),
		}

Country Name (2 letter code) [AU]:CN
State or Province Name (full name) [Some-State]:BeiJing
Locality Name (eg, city) []:BeiJing
Organization Name (eg, company) [Internet Widgits Pty Ltd]:tech
Organizational Unit Name (eg, section) []:tech .etc
Common Name (e.g. server FQDN or YOUR name) []:xiaoyu
Email Address []:
###