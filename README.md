# Docker Stack Manager (DSM)

A modular, Git-style CLI tool for managing multi-group Docker Compose deployments on Windows (Git Bash) and Linux.

## 📂 Project Structure

```text
docker/
├── env.sh              # Shared environment & config (READ-ONLY)
├── manage              # Main entry point (the 'd' command)
├── stacks.txt          # Auto-generated index of stacks
├── scripts/            # Modular worker scripts
│   ├── manage-up       # Starts containers
│   ├── manage-down     # Stops containers
│   ├── manage-status   # Dashboard & health check
│   └── ...             # (discover, check, edit, logs)
└── containers/         # Your Docker configurations
    ├── networking/     # Logical groupings
    │   └── fing/       # Individual stack folder
    └── apps/
        └── gimp/
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

## 🛠 Usage

The tool is invoked using the d alias followed by a command:

| Command | Description |
| :--- | :--- |
| `d discover` | Scans containers/ and updates the stacks.txt index. |
| `d status` | Shows a professional dashboard of running containers and resource usage. |
| `d check [--ignore-latest]` | Validates YAML syntax for all stacks without starting them. |
| `d up` | Starts all stacks listed in stacks.txt. |
| `d down` | Stops and removes all stacks listed in stacks.txt. |
| `d edit [name]` | Opens the docker-compose.yml of a specific stack in vi. |
| `d logs [name] [-f]` | Tails the logs for a specific stack (e.g., d logs fing -f). |
| `d prune` | Deep-cleans unused Docker images, containers, and networks. |

## 📝 Adding New Containers

1. Create a subfolder in `containers/` (e.g., `containers/media/plex`).

2. Place your `docker-compose.yml` inside that folder.

3. Run `d` discover to add it to your management rotation.

## ⚙️ Configuration (`env.sh`)

Global variables like OS detection (`MSYS_NO_PATHCONV`) and the `status_title` UI routine are managed in `env.sh`. This file is *sourced*, not executed, to maintain a single source of truth across all modular scripts.


---

### How to use this file

1.  Run `vi ~/docker/README.md`.
2.  Paste the content above.
3.  Now, whenever you are in your terminal, you can simply type `cat ~/docker/README.md` to see your manual.

