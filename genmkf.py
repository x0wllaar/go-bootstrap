assert __name__ == "__main__", "Run as script"

import sys

STEP_FORMAT = """
trees/{version}/bin/go: trees/{previous}/bin/go
	rm -rf trees/{version}
	cd gorepo && git worktree prune
	mkdir -p trees/{version}
	cd gorepo && git worktree add ../trees/{version}/ release-branch.{version}
	cd trees/{version} && git pull
	cd trees/{version}/src && /usr/bin/env PATH="$(shell realpath ./trees/{previous})/bin:$(PATH)" ./make.bash
{version}: trees/{version}/bin/go
""".strip()


def go_ver_to_int(go_ver):
    assert go_ver.startswith("go1."), f"Invalid version {go_ver}"
    return int(go_ver.split(".")[1])


def get_required_ver(go_ver):
    int_ver = go_ver_to_int(go_ver)
    if int_ver <= 19:
        return "go1.4"
    if int_ver >= 20 and int_ver <= 21:
        return "go1.17"
    if int_ver >= 22 and int_ver <= 23:
        return "go1.20"
    req_ver = int_ver - 2
    if req_ver % 2 == 1:
        req_ver -= 1
    return f"go1.{req_ver}"


known_vers = {"go1.4"}


def generate_path(go_ver):
    if go_ver in known_vers:
        return
    req_ver = get_required_ver(go_ver)
    if req_ver not in known_vers:
        generate_path(req_ver)
    rec = STEP_FORMAT.format(version=go_ver, previous=req_ver)
    print(rec)
    print("")
    known_vers.add(go_ver)


assert len(sys.argv) > 1
generate_path(sys.argv[1])
