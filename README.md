# Docker Stack Manager (DSM)

A professional, modular CLI toolset for managing Docker Compose stacks. Designed for isolation, stability, and surgical control over service groups.

## 📂 Architecture
- **Isolated Projects**: Each stack is assigned a unique project name (`-p`) based on its directory path, preventing "orphan container" warnings.
- **Library-Driven**: Core logic resides in `env.sh` (Read-only), ensuring consistency across all management scripts.
- **Hierarchical**: Supports single stacks (e.g., `iot/home-assistant`) or entire groups (e.g., `iot`).

## 🛠 Usage
The tool is invoked via the `d` alias. All lifecycle commands support an optional `[target]` parameter.

| Command | [Target] Capability | Description |
| :--- | :--- | :--- |
| `d up` | `[group]` or `[stack]` | Starts target(s) with `--no-build`. |
| `d down` | `[group]` or `[stack]` | Stops and removes target(s). |
| `d restart` | `[group]` or `[stack]` | Bounces the container processes. |
| `d status` | `[group]` | Shows a dashboard (filtered if group is provided). |
| `d check` | `--ignore-latest` | Validates YAML. Warns on `:latest` tags (except in `security/`). |
| `d discover` | N/A | Rebuilds the `stacks.txt` index. |
| `d edit` | `[stack]` | Opens the specific `docker-compose.yml` in `vi`. |
| `d logs` | `[stack]` | Tails logs (supports flags like `-f`). |

## 📁 Directory Structure
```text
~/docker/
├── env.sh              # Central functions (chmod 644)
├── manage              # Main router (chmod +x)
├── stacks.txt          # Auto-generated index
├── scripts/            # Parameter-aware workers
└── containers/         
    ├── iot/            # Group: iot
    │   └── home-assistant/
    ├── networking/     # Group: networking
    │   └── fing/
    └── security/       # Group: security (Policy: latest-tag allowed)
```

## 🚀 Setup

1. Permissions: Ensure the scripts are executable and the environment library is protected:

```Bash
chmod +x manage scripts/*
chmod 644 env.sh stacks.txt
```

2. Shell Alias: Add this to your ~/.bashrc or ~/.bash_profile:

```Bash
alias d='~/docker/manage'
```

## 📝 Adding New Containers

1. Create a subfolder in `containers/` (e.g., `containers/media/plex`).

2. Place your `docker-compose.yml` inside that folder.

3. Run `d` discover to add it to your management rotation.

## ⚙️ Configuration (`env.sh`)

Global variables like OS detection (`MSYS_NO_PATHCONV`) and the `status_title` UI routine are managed in `env.sh`. This file is *sourced*, not executed, to maintain a single source of truth across all modular scripts.

## 🔐 Policies & Best Practices

1. The `:latest` Rule: Do not use `:latest` in production (e.g., `iot` or `infra`). Always pin versions for stability.

2. Security Exception: Containers in the `security/` group are exempt from `:latest` warnings to ensure signature updates.

3. Adding Services:

* Create a folder: `containers/[group]/[service]`.

* Add `docker-compose.yml`.

* Run `d discover` to register the new stack.
