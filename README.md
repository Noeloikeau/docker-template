# Development Container Template Guide

This guide explains how to use this development container template for containerizing Python projects, from initial setup through to production deployment. It assumes you're comfortable with Python development but may be new to Docker and containerization.

## Prerequisites

- VS Code installed
- Docker Desktop installed and running
- VS Code "Dev Containers" extension installed
- Basic familiarity with Python development

## Quick Start

1. Copy this template to your project:
   ```bash
   cp -r /path/to/template/{.devcontainer,config,.dockerignore} /path/to/your/project
   ```

2. Open your project in VS Code:
   ```bash
   code /path/to/your/project
   ```

3. When prompted "Reopen in Container", click yes (or press F1, type "Reopen in Container")

You're now developing inside a container! The terminal in VS Code is running inside the container, but your files are still on your local system.

## Directory Structure

```
📦 Project Root
├── .coverage                   # Coverage data file
├── .devcontainer/             # Container configuration
│   ├── devcontainer.json      # VS Code container settings
│   └── Dockerfile             # Container build definition
├── .dockerignore              # Docker ignore rules
├── .flake8                    # Flake8 configuration
├── .pytest_cache/             # Pytest cache directory
├── .vscode/                   # VS Code settings
│   └── settings.json          # Editor configuration
├── config/                    # Project configuration
│   ├── apt-packages.txt       # System dependencies
│   └── requirements.txt       # Python dependencies
├── pyproject.toml             # Python project configuration
├── scripts/                   # Utility scripts
│   └── lint.sh               # Linting script
├── src/                       # Source code
│   ├── __init__.py
│   └── main.py               # Main application code
└── tests/                     # Test files
    ├── __init__.py
    └── test_main.py          # Test cases
```

## Development Workflows

### 1. VS Code Dev Container (Recommended for Development)

This method provides the full VS Code experience inside a container.

a) First Time Setup:
- Open project in VS Code
- Click "Reopen in Container" when prompted
- Wait for container to build (watch progress in VS Code's bottom panel)

b) Daily Development:
- Edit files normally in VS Code
- Use integrated terminal for commands
- Debugger and extensions work as normal
- Container rebuilds automatically when you change dependencies

c) Debugging:
- Set breakpoints by clicking left of line numbers
- Press F5 to start debugging
- Use Debug Console to inspect variables
- Debug toolbar appears automatically

### 2. Docker CLI with Volume Mounting (Alternative Development Method)

This method lets you use any editor while running code in the container.

```bash
# Build the container
docker build -t my_project:dev .

# Run with current directory mounted
docker run -it -v $(pwd):/workspace my_project:dev

# Run with specific ports exposed (e.g., for web apps)
docker run -it -v $(pwd):/workspace -p 8000:8000 my_project:dev

# Run specific commands
docker run -it -v $(pwd):/workspace my_project:dev python -m pytest
```

### 3. Multiple Module Development (Using Docker Compose)

When working with multiple interrelated modules:

1. Create a `docker-compose.yml` file:
```yaml
version: '3.8'
services:
  module1:
    build:
      context: ./module1
    volumes:
      - ./module1:/workspace
    ports:
      - "8000:8000"

  module2:
    build:
      context: ./module2
    volumes:
      - ./module2:/workspace
    ports:
      - "8001:8001"
    depends_on:
      - module1
```

2. Run your multi-module environment:
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Access specific module
docker-compose exec module1 bash

# Stop everything
docker-compose down
```

## Common Tasks

### Adding Dependencies

1. Python packages:
   - Add to `config/requirements.txt`
   - Rebuild container (Command Palette → "Rebuild Container")

2. System packages:
   - Add to `config/apt-packages.txt`
   - Rebuild container

### Running Tests

Inside VS Code terminal (container):
```bash
python -m pytest
```

Or via Docker CLI:
```bash
docker run -it -v $(pwd):/workspace my_project:dev python -m pytest
```

### Using Debugger

1. Set up `launch.json` (VS Code will help create this)
2. Add configuration:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal"
        }
    ]
}
```
3. Press F5 to debug current file

### Production Deployment

1. Build production image:
```bash
docker build --target prod -t my_project:prod .
```

2. Run without volume mounting:
```bash
docker run my_project:prod
```

## Troubleshooting

### Container Won't Build
1. Check Docker Desktop is running
2. Try rebuilding with no cache:
   ```bash
   docker build --no-cache .
   ```

### VS Code Can't Connect to Container
1. Reload VS Code window
2. Check Docker Desktop status
3. Try "Rebuild Container" from Command Palette

### Python Imports Not Working
1. Check `PYTHONPATH` in container
2. Verify file locations in mounted volume
3. Try restarting Python language server:
   - Command Palette → "Python: Restart Language Server"

### Volume Mounting Issues
1. Check path in docker run command
2. Verify file permissions
3. Try with absolute paths:
   ```bash
   docker run -it -v "$(pwd)":/workspace my_project:dev
   ```

## Best Practices

1. Development:
   - Use VS Code Dev Containers for best experience
   - Keep dependencies updated in config files
   - Use volume mounting for development
   - Commit your .devcontainer configuration

2. Production:
   - Build separate production images
   - Don't use volume mounts in production
   - Use multi-stage builds to minimize image size
   - Tag images with versions

3. Testing:
   - Run tests inside container
   - Use continuous integration
   - Test production builds before deployment

## Need Help?

1. Check Docker logs:
   ```bash
   docker logs <container_id>
   ```

2. Access container directly:
   ```bash
   docker exec -it <container_id> bash
   ```

3. Review VS Code Dev Containers documentation:
   - Help → Dev Containers documentation

4. Common VS Code commands (Command Palette → type these):
   - "Dev Containers: Rebuild Container"
   - "Dev Containers: Open Container Logs"
   - "Dev Containers: Show Container Performance"

Remember: The container provides isolation but your files still live on your local system. Changes are preserved between container restarts because of volume mounting.
