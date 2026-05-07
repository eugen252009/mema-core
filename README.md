# 🍱 Mema: The Minimalist Meta-Manager

**Mema** is not a bloated package manager. It is a POSIX-sh framework designed to manage binaries and environments deterministically in `/opt`, without polluting your system with unnecessary dependencies.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://img.shields.io/badge/CI-Docker--Tested-brightgreen)](https://github.com/eugen252009/mema-core)

---

## 🍽️ The Buffet Philosophy
Think of this repository as an **"All-You-Can-Eat" Buffet**:
*   **The Content:** We provide recipes for a vast array of tools (Go, Rust, Zig, Bun, Node, etc.).
*   **Your Choice:** Just because the buffet is full doesn't mean you have to eat everything. You only "consume" (install) the tools you actually need for your current project.
*   **The Result:** Your system stays lean. Only the specific `.deb` packages you choose to build will ever touch your `/opt/mema` directory.

## 🏗️ Architecture
The Mema ecosystem is split into two distinct parts:

1.  **[mema-core](https://github.com/eugen252009/mema-core):** The "Kitchen." This is the engine module providing installation primitives (`mema_install`, `mema_link`), caching, and deterministic symlinking.
2.  **[mema-recipes](https://github.com/eugen252009/mema-recipes):** The "Buffet" (this repo). A collection of shell-based recipes defining how binaries are fetched, verified, and linked.

---

## 🚀 Quick Start (3 Steps to Your Tool)

### 1. Kitchen Setup
First, install the core system (requires root):
```bash
curl -fsSL https://eugen252009.github.io/mema-core/install_repo.sh | sudo bash
sudo apt update && sudo apt install mema
```

### 2. Load Recipes (Submodule)
If you are developing Mema-Core locally or building custom recipes:
```bash
git clone --recursive https://github.com/eugen252009/mema-core.git
cd mema-core/recipes
```

### 3. Install Tools
Mema uses `fzf` for lightning-fast, interactive selection:
```bash
mema use        # Interactively switch between installed versions
mema choose go  # Interactively choose a version to install from a recipe
```

---

## 🛠️ "Cooking" a Custom Recipe
A Mema recipe is pure shell script—minimalist and free of "Architecture Astronaut" over-engineering.

Example tool recipe:
```bash
mema_install() {
    # Download & verify via core primitive
    mema_download "$URL" "tool.tar.gz" "$HASH"
    
    # Extract into the deterministic Mema directory
    tar -C "$MEMA_INSTALL_DIR" -xzf tool.tar.gz
    
    # Create symlinks in /usr/local/bin
    mema_link "bin/tool" "tool"
}
```

---

## 🧼 Why Mema?
*   **Zero Bloat:** No Python/Node runtime required. Just `sh`, `curl`, and `tar`.
*   **System Integrity:** Everything stays contained in `/opt/mema`. No files scattered across `/usr/bin`.
*   **Version Switching:** Run multiple versions of Go or Node side-by-side without complex "manager-managers."
*   **Dev-Friendly:** Adding a new tool takes exactly as long as copying a download URL and a hash.

---

**Pick what you need. Build what you use. Enjoy the buffet.** 

*Developed by [Eugen Lupricht](https://github.com/eugen252009)*
