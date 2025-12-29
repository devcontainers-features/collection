# Neovim

Hyperextensible Vim-based text editor with essential tools for plugin support.

## What's Included

- **Neovim** - The text editor itself
- **fd** - Fast file finder (used by telescope.nvim and other plugins)
- **ripgrep** - Fast text search (used by telescope.nvim and other plugins)
- **pynvim** - Python provider for Neovim (if Python is available)
- **neovim npm package** - Node.js provider for Neovim (if npm is available)

## Example Usage

```json
"features": {
    "ghcr.io/devcontainers-features/catalog/nvim:1": {
        "version": "latest"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|------------|-------------|------|---------------|
| version | Select the Neovim version to install. | string | latest |

---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json)._
