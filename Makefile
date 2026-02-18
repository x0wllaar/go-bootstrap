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
	cd gorepo && git fetch --all && git pull

latest: repoupdate
	$(MAKE) $(shell cd gorepo && bash ../getlatest.bash)

install-latest: repoupdate
	$(MAKE) install-$(shell cd gorepo && bash ../getlatest.bash)

cleantree-latest: repoupdate
	$(MAKE) cleantree-$(shell cd gorepo && bash ../getlatest.bash)

update-latest: repoupdate
	$(MAKE) update-$(shell cd gorepo && bash ../getlatest.bash)

go%: prelude.Makefile repoupdate
	cp prelude.Makefile _$@.Makefile
	echo -e "\n\n" >> _$@.Makefile
	bash ./genmkf.bash $@ >> _$@.Makefile
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
