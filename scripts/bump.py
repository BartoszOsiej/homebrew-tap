#!/usr/bin/env python3
"""Auto-bump Homebrew formulas from live GitHub releases."""
import hashlib, json, os, urllib.request

REPO_SRC = "cybersec-tools"
OWNER = "BartoszOsiej"
TOOLS = ["netrecon", "hashsleuth"]
DARWIN_TARGETS = ["aarch64-apple-darwin", "x86_64-apple-darwin"]
DESCS = {
    "netrecon": "Fast network reconnaissance - host discovery & port scanning (Rust)",
    "hashsleuth": "Multi-threaded hash identification & cracking toolkit (Rust)",
}

def api(url):
    req = urllib.request.Request(url, headers={"User-Agent": "tap-bot"})
    return json.load(urllib.request.urlopen(req, timeout=30))

def sha256_url(url):
    req = urllib.request.Request(url, headers={"User-Agent": "tap-bot"})
    h = hashlib.sha256()
    with urllib.request.urlopen(req, timeout=120) as r:
        for chunk in iter(lambda: r.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()

rel = api(f"https://api.github.com/repos/{OWNER}/{REPO_SRC}/releases/latest")
tag = rel["tag_name"].lstrip("v")
assets = {a["name"]: a["browser_download_url"] for a in rel.get("assets", [])}

changed = []
for tool in TOOLS:
    pairs = []
    ok = True
    for t in DARWIN_TARGETS:
        asset = f"{tool}-{t}"
        if asset not in assets:
            ok = False
            break
        pairs.append((t, assets[asset], sha256_url(assets[asset])))
    if not ok:
        print(f"{tool}: brak assetow darwin w {rel['tag_name']} - pomijam")
        continue

    arm, x86 = pairs[0], pairs[1]
    blocks = f"""    if Hardware::CPU.arm?
      url "{arm[1]}"
      sha256 "{arm[2]}"
    else
      url "{x86[1]}"
      sha256 "{x86[2]}"
    end"""
    installs = "\n".join(
        f'      binary "{tool}-{t}"' for t in DARWIN_TARGETS)
    installs = ("    if Hardware::CPU.arm?\n" +
                f'      binary "{tool}-{arm[0]}"\n' +
                "    else\n" +
                f'      binary "{tool}-{x86[0]}"\n' +
                "    end")

    cls = "".join(w.capitalize() for w in tool.split("-"))
    content = f'''class {cls} < Formula
  desc "{DESCS[tool]}"
  homepage "https://github.com/{OWNER}/{REPO_SRC}"
  version "{tag}"
  license "MIT"

  on_macos do
{blocks}
  end

  def install
{installs}
  end

  test do
    system "#{{bin}}/{tool}", "--help"
  end
end
'''
    path = f"Formula/{tool}.rb"
    old = open(path).read() if os.path.exists(path) else ""
    if old != content:
        open(path, "w").write(content)
        changed.append(path)
        print(f"{path}: -> v{tag}")
    else:
        print(f"{path}: bez zmian")
