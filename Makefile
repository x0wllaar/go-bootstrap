default: update-latest

GO_INSTALL_TARGET ?= "go"
GO_INSTALL_REPO ?= "https://go.googlesource.com/go"

clean: cleantrees
	rm -rf gorepo
	rm -r go || true
	rm _go*.Makefile || true

cleantrees:
	rm -r ./trees || true
	(cd gorepo && git worktree prune) || true

gorepo:
	git clone $(GO_INSTALL_REPO) gorepo

repoupdate: gorepo
	cd gorepo && git fetch --all

latest: repoupdate
	$(MAKE) $(shell cd gorepo && python ../getlatest.py)

install-latest: repoupdate
	$(MAKE) install-$(shell cd gorepo && python ../getlatest.py)

cleantree-latest: repoupdate
	$(MAKE) cleantree-$(shell cd gorepo && python ../getlatest.py)

update-latest: repoupdate
	$(MAKE) update-$(shell cd gorepo && python ../getlatest.py)

go%: prelude.Makefile repoupdate
	cp prelude.Makefile _$@.Makefile
	echo -e "\n\n" >> _$@.Makefile
	python genmkf.py $@ >> _$@.Makefile
	$(MAKE) -f _$@.Makefile $@
	rm _$@.Makefile

install-go%: go%
	rm -r $(GO_INSTALL_TARGET) || true
	cp -r ./trees/go$* $(GO_INSTALL_TARGET)

cleantree-go%:
	rm -r ./trees/go$* || true
	(cd gorepo && git worktree prune) || true

update-go%:
	$(MAKE) cleantree-go$*
	$(MAKE) install-go$*
