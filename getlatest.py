assert __name__ == "__main__", "Run as script"

import subprocess


def go_ver_to_int(go_ver):
    assert go_ver.startswith("go1."), f"Invalid version {go_ver}"
    return int(go_ver.split(".")[1])


all_branch_res = subprocess.run(
    ["git", "branch", "--all"], capture_output=True, text=True, check=True
)
assert all_branch_res.returncode == 0, "Failed to get branches"
all_branch_str = all_branch_res.stdout.strip()

branches = set()
for b in all_branch_str.split("\n"):
    b = b.strip().removeprefix("*").strip()
    if len(b) > 0:
        branches.add(b)

release_branches = {b for b in branches if "release-branch.go" in b}
go_versions = {
    b[b.index("release-branch.") + len("release-branch.") :] for b in release_branches
} - {"go1"}
go_int_versions = {go_ver_to_int(v) for v in go_versions}
go_sorted_versions = sorted(go_int_versions)

print(f"go1.{go_sorted_versions[-1]}")
