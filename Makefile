#
# This file assumes that naviserver and the reverse proxy modules is installed
# see:
#    https://bitbucket.org/naviserver/naviserver/src/master/
#    https://bitbucket.org/naviserver/revproxy/src/master/
#
NS=/usr/local/ns/

%MB:
	dd if=/dev/urandom of=$*MB bs=1MB count=$*

%KB:
	dd if=/dev/urandom of=$*KB bs=1KB count=$*

all: 100KB 1MB 2MB 10MB 100MB
	mkdir -p "$(NS)/pages-backend"
	mkdir -p $(NS)/pages-revproxy
	cp receiver.tcl $(NS)/pages-backend/
	@echo 'Start servers:'
	@echo '   NS_HTTP_PORT=18091 /usr/local/ns/bin/nsd -f -u nsadmin -g nsadmin -t nsd-config-backend.tcl'
	@echo '   NS_HTTPS_PORT=48090 NS_HTTP_PORT=18090 /usr/local/ns/bin/nsd -f -u nsadmin -g nsadmin -t nsd-config-revproxy.tcl'
	@echo ''
	@echo 'Direct backend requests:'
	@echo '   curl -v -X POST -T 100KB http://127.0.0.1:18091/receiver.tcl'
	@echo '   curl -v -X POST -T 1MB http://127.0.0.1:18091/receiver.tcl'
	@echo '   curl -v -X POST -T 10MB http://127.0.0.1:18091/receiver.tcl'
	@echo ''
	@echo 'Reverse proxy requests:'
	@echo '   curl -v -X POST -H 'Expect:' -T 100KB http://127.0.0.1:18090/receiver.tcl'
	@echo '   curl -v -X POST -H 'Expect:' -T 1MB http://127.0.0.1:18090/receiver.tcl'
	@echo '   curl -v -X POST -H 'Expect:' -T 10MB http://127.0.0.1:18090/receiver.tcl'
	@echo ''
	@echo '   curl -v -k -X POST -H 'Expect:' -T 100KB https://127.0.0.1:48090/receiver.tcl'
	@echo '   curl -v -k -X POST -H 'Expect:' -T 1MB https://127.0.0.1:48090/receiver.tcl'
	@echo '   curl -v -k -X POST -H 'Expect:' -T 10MB https://127.0.0.1:48090/receiver.tcl'

clean:
	rm *MB *KB
