all :
	true

install :
	mkdir -p $(DESTDIR)/usr/bin
	install -m 755 go-sleep.sh $(DESTDIR)/usr/bin
	install -m 755 ssh-add-all.sh $(DESTDIR)/usr/bin

