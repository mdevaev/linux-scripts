all :
	true

install :
	mkdir -p $(DESTDIR)/usr/bin
	install -m 755 go-sleep.sh $(DESTDIR)/usr/bin/go-sleep
	install -m 755 ssh-add-all.sh $(DESTDIR)/usr/bin/ssh-add-all
	install -m 755 makepass.sh $(DESTDIR)/usr/bin/makepass
	install -m 755 cuesplit.sh $(DESTDIR)/usr/bin/cuesplit

