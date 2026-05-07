# 🍱 Mema: The Minimalist Meta-Manager

**Mema** is a high-performance, POSIX-sh framework designed for deterministic binary management. It is not a bloated package manager; it is a lightweight infrastructure designed to manage toolchains (Go, Rust, Zig, Node) in `/opt/mema` without polluting your system or requiring heavy runtimes.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-lightgrey)](https://github.com/eugen252009/mema-core)

---

## 💡 The Philosophy
Mema decouples **installation logic** (how a tool is built) from **distribution** (how a tool is delivered).
*   **Modular Architecture:** The Core provides the primitives (`mema_install`, `mema_link`), while Recipes provide specific tool definitions.
*   **System Integrity:** Zero pollution of `/usr/bin`. All binaries are contained within a deterministic directory structure.
*   **Explicit Control:** You only install the specific toolchains required for your current environment.

## 🏗️ Architecture
The ecosystem consists of two decoupled repositories:

1.  **[mema-core](https://github.com/eugen252009/mema-core):** The Engine. Handles caching, deterministic symlinking, and GPG-signed APT distribution.
2.  **[mema-recipes](https://github.com/eugen252009/mema-recipes):** The Registry. A collection of shell-based recipes for fetching and verifying binaries.

---

## 🚀 Quick Start

### 1. Configure Repository
Mema is distributed via a custom, GPG-signed APT repository. Install the core system with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/eugen252009/mema-core/refs/heads/main/install_repo.sh | sudo bash
sudo apt update && sudo apt install mema
```

### 2. Install Toolchains
Choose the specific languages or tools you need. You can lock specific versions or use the `-latest` meta-package for automated updates:

```bash
# Example: Install the Go toolchain
sudo apt install mema-go

# OR: Always keep Go updated to the latest version
sudo apt install mema-go-latest
```

### 3. Usage & Switching
Mema features an interactive UI (via `fzf`) to switch between installed versions instantly:

```bash
mema use      # Interactively switch between active versions
mema choose   # Interactively install a version from a recipe
```

---

## 🛠️ Writing a Recipe
A Mema recipe is pure shell script—adhering to Data-Oriented Design and avoiding "Architecture Astronaut" over-engineering.

```bash
mema_install() {
    # Download & verify using core primitives
    mema_download "$URL" "tool.tar.gz" "$HASH"
    
    # Extract into the deterministic Mema directory
    tar -C "$MEMA_INSTALL_DIR" -xzf tool.tar.gz
    
    # Link binaries to be available in PATH
    mema_link "bin/tool" "tool"
}
```

---

## 🧼 Why Mema?
*   **Zero Runtime Bloat:** No dependency on Python, Node, or Go on the host system. Requires only `sh`, `curl`, and `tar`.
*   **Deterministic Environments:** Predictable paths in `/opt/mema` ensure reproducible development setups.
*   **Side-by-Side Versions:** Run multiple versions of the same software simultaneously without conflicts.
*   **CI/CD Driven:** Automated pipeline that builds, signs, and deploys Debian packages via GitHub Actions and GitHub Pages.

---

**Built for efficiency. Engineered for stability.**

*Developed by [Eugen Lupricht](https://github.com/eugen252009)*
