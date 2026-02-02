# ogit.sh — Workspace Orchestrator CLI

A fast, colorful CLI to manage your GitHub workspace: authenticate, list orgs/repos, clone repositories into a tidy local directory, and inspect local repo status — with rich formatting, filters, autocompletion, and machine-readable summaries.

---

## Overview
- Authenticates via GitHub CLI (`gh`).
- Lists user and organization repositories you can access.
- Clones repos into a structured directory: `DIR/ORG/REPO`.
- Shows local repo status: branch, staged/unstaged changes, and remote existence.
- Consistent, aligned, colored output with per‑organization summaries.
- Powerful flags for filtering, compact views, and CSV/JSON exports.
- Built-in Bash, Zsh, and Fish shell autocompletion.

## Requirements
- Bash 4+ (script runs with `#!/bin/bash`).
- GitHub CLI (`gh`) installed and authenticated: `gh auth login`.
- Git installed.
- Optional for completions:
  - Bash: `bash-completion` package loaded in your shell.
  - Zsh: `compinit` initialized.
  - Fish: auto-loads from `~/.config/fish/completions`.

## Installation

Install the binary and add it to your `PATH`, then enable autocompletion.

### Make-based install (recommended)

```bash
# From the ogit project directory
make install

# Install completions for all shells (bash, zsh, fish)
make completion

# Or individually
make completion-bash
make completion-zsh
make completion-fish
```

### Binary install

```bash
mkdir -p "$HOME/.local/bin"
cp ./ogit.sh "$HOME/.local/bin/ogit"
chmod +x "$HOME/.local/bin/ogit"
```

### Add to PATH (Bash)

```bash
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  source "$HOME/.bashrc"
fi
```

### Autocompletion setup

#### Bash

```bash
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion
mkdir -p "$HOME/.local/share/bash-completion"
ogit install completion > "$HOME/.local/share/bash-completion/ogit"
echo 'if [ -f ~/.local/share/bash-completion/ogit ]; then . ~/.local/share/bash-completion/ogit; fi' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

#### Zsh

```bash
mkdir -p "$HOME/.zsh/completions"
ogit install completion zsh > "$HOME/.zsh/completions/_ogit_sh"
echo 'fpath+=(~/.zsh/completions)' >> "$HOME/.zshrc"
echo 'autoload -U compinit && compinit' >> "$HOME/.zshrc"
source "$HOME/.zshrc"
```

#### Fish

```bash
mkdir -p "$HOME/.config/fish/completions"
ogit install completion fish > "$HOME/.config/fish/completions/ogit.fish"
# Fish auto-loads completions on new sessions
```

## Quick Start
```bash
# Authenticate
ogit login

# List organizations and repositories (remote)
ogit get orgs
ogit get repos

# Inspect local repos: branch + git state
ogit show repos

# Clone everything (respecting filters) into the target directory
ogit create workplace
```

## Usage
```text
Usage: ./ogit.sh [-h|--help] [--user] [--orgs <args>] [--exorgs <args>] [--repos <args>] [--dir <arg>] [--summary-only] [--no-header] [--format <csv|json>] [--format-header] [--pretty-json] [--] <command>
```

### Options
- `-h, --help`: Show help and exit.
- `--user`: Limit scope to user repositories only.
- `--orgs <args>`: Include specific organizations (comma-separated). Example: `--orgs omniopenverse,appseed`.
- `--exorgs <args>`: Exclude specific organizations (comma-separated). Default excludes `42-ready-player-hackathon`.
- `--repos <args>`: Include specific repositories (comma-separated).
- `--dir <arg>`: Target directory for clones (default `~/workplace`).
- `--summary-only`: Print per-organization summary footer only (suppress per-repo lines).
- `--no-header`: Suppress header box lines; useful for piping to tools.
- `--format <csv|json>`: Output summaries in machine-readable CSV or JSON.
- `--format-header`: With `--format=csv`, print a header row once (per command).
- `--pretty-json`: With `--format=json`, output indented multi-line JSON.
- `--`: Stop parsing options (useful when positional args start with `-`).

### Commands
- `login`: Authenticate with GitHub via `gh`. If already authenticated, prints status and exits.
- `create workplace`: Clone repositories into the target directory.
  - Respects `--user`, `--orgs`, `--exorgs`, `--repos`, `--dir`.
  - Uses per‑organization folders and skips repos already cloned.
- `get user`: Print the authenticated GitHub username.
- `get orgs`: List organizations for the authenticated user.
  - With `--user`, scope is limited to the user (no orgs listed).
- `get repos`: List remote repositories per organization; shows cloned/not cloned status (does not clone).
- `show repos`: Inspect local repositories under `--dir` and print:
  - Current branch
  - State: Clean / Staged changes / Unstaged changes / Staged & Unstaged changes
  - “Remote missing” when the repo does not exist on GitHub
- `completion [bash|zsh|fish]`: Output shell completion scripts to stdout.
- `install completion [bash|zsh|fish]`: Install completion scripts to user directories.

 

## Autocompletion
The CLI provides dynamic completions for options, commands, orgs, and repos.

### Bash
```bash
# Ensure bash-completion is installed and loaded
[[ -r /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# Generate completion (stdout) and save to a file
./ogit.sh install completion > ~/.local/share/bash-completion/ogit.sh

# Source it from ~/.bashrc (once)
echo 'if [ -f ~/.local/share/bash-completion/ogit.sh ]; then . ~/.local/share/bash-completion/ogit.sh; fi' >> ~/.bashrc

# Reload current shell to enable completions
source ~/.bashrc
```
Tips:
- Use `ogit` or `ogit.sh` as the command name. If invoking by path, consider an alias:
  `alias ogit="$PWD/ogit.sh"`.

### Zsh
```bash
# Generate completion (stdout) and save to a file
./ogit.sh install completion zsh > ~/.zsh/completions/_ogit.sh

# Add to ~/.zshrc
fpath+=(~/.zsh/completions)
autoload -U compinit && compinit
```

### Fish
```bash
# Generate completion (stdout) and save to a file
./ogit.sh install completion fish > ~/.config/fish/completions/ogit.sh.fish

# Fish auto-loads from ~/.config/fish/completions
```

## Output & Styling
- Uses ANSI colors and aligned curly‑brace info blocks for readability.
- Per‑organization headers are box‑lined (`╭`, `╰`).
- `--summary-only` prints just the footer summary per org.
- `--no-header` suppresses the header box line; great for dashboards/pipes.
- Machine readable:
  - `--format json` or `--format csv` outputs summary rows without styling.
  - `--format-header` adds CSV header.
  - `--pretty-json` prints indented JSON.

## Filtering Semantics
- Org selection: `--orgs` includes only listed orgs; `--exorgs` excludes listed orgs.
- Repo selection: `--repos` includes only listed repos.
- `--user` restricts scope to the user account; organizations are suppressed.

## Local Status Rules (show repos)
- Branch: detected via `git rev-parse --abbrev-ref HEAD`.
- State classification (from `git status --porcelain`):
  - Clean: no changes.
  - Staged changes: staged entries present.
  - Unstaged changes: unstaged or untracked entries present.
  - Staged & Unstaged changes: both present.
- Remote existence check: `gh repo view ORG/REPO`.

## Exit Codes & Errors
- Error output is styled: `{ error: <message>, code: <N> }`.
- Exit codes:
  - 0: Success.
  - 1: Login failed.
  - 2: Unknown option.
  - 3: Missing/invalid option argument (e.g., `--orgs` requires a value).
  - 4: Invalid command.
  - 5: Target directory missing (for local status).
  - 6: Completion install failed.

## Examples

### Authenticate
```bash
./ogit.sh login
```

### List basics
```bash
./ogit.sh get user
./ogit.sh get orgs
./ogit.sh get repos
```

### Filter by orgs and repos
```bash
./ogit.sh --orgs omniopenverse --repos app101,docs get repos
```

### Clone workspace
```bash
./ogit.sh --dir "$HOME/workplace" create workplace
```

### Local repository status
```bash
./ogit.sh --orgs omniopenverse show repos
```

### Compact summaries
```bash
# Footer-only summaries, no headers, for dashboards
./ogit.sh --orgs omniopenverse --summary-only --no-header get repos
./ogit.sh --orgs omniopenverse --summary-only --no-header show repos
./ogit.sh --orgs omniopenverse --summary-only --no-header create workplace
```

### Machine-readable outputs
```bash
# JSON
./ogit.sh --orgs omniopenverse --summary-only --no-header --format json get repos
./ogit.sh --orgs omniopenverse --summary-only --no-header --format json --pretty-json show repos

# CSV with header
./ogit.sh --orgs omniopenverse --summary-only --no-header --format csv --format-header create workplace
```

## Troubleshooting
- “gh not found”: install GitHub CLI and ensure it’s in `PATH`.
- “Not authenticated”: run `./ogit.sh login` or `gh auth login`.
- Bash completion not working:
  - Install `bash-completion` and ensure it’s sourced in `~/.bashrc`.
  - Confirm the installed script at `~/.local/share/bash-completion/ogit.sh` is sourced.
- Zsh completion not working:
  - Ensure `fpath+=(~/.zsh/completions)` and run `compinit`.
- Fish completion not working:
  - Ensure file exists at `~/.config/fish/completions/ogit.sh.fish` and start a new fish session.
- Slow or rate-limited listings: GitHub API quotas may apply; try reducing `--limit` or filtering orgs.

## Notes
- Default excluded org: `42-ready-player-hackathon` via `--exorgs`.
- Cloning uses `gh repo clone` with quiet output to reduce noise.
- The script aligns visual columns per organization for readability.

## FAQ
- “Does it list private repos?” — Yes, if your authenticated account has access.
- “Can I run by path?” — Yes; for best completion experience, add an alias: `alias ogit="/path/to/ogit.sh"`.
- “How do I export summaries across multiple orgs?” — Use `--orgs` with a comma list; combine with `--format` flags and redirect output.

---

Happy automating! If you’d like aggregated outputs (single JSON array or combined CSV across orgs), consider adding an `--aggregate` flag; the CLI is structured to extend easily.
