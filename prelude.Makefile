trees/go1.4/bin/go: gorepo
	rm -rf trees/go1.4
	cd gorepo && git worktree prune
	mkdir -p trees/go1.4
	cd gorepo && git worktree add ../trees/go1.4/ release-branch.go1.4
	cd trees/go1.4 && git pull
	cd trees/go1.4/src && /usr/bin/env CGO_ENABLED=0 CC="$(GO_INSTALL_CC)" ./make.bash
go1.4: trees/go1.4/bin/go
