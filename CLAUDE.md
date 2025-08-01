# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### LocalStack Development
- Start LocalStack: `make localstack`
- This starts a LocalStack container via Docker Compose for AWS service emulation

### Docker Compose
- Start services: `docker compose up -d`
- The main service is LocalStack running on ports 4566 and 4510-4559

## Project Architecture

This is a minimal CNCF (Cloud Native Computing Foundation) related project that currently consists of:

- **Infrastructure setup**: Uses LocalStack for local AWS service emulation
- **Container orchestration**: Docker Compose configuration for development environment
- **Build automation**: Basic Makefile for common development tasks

### Key Files
- `Makefile`: Contains development commands, primarily for LocalStack management
- `compose.yaml`: Docker Compose configuration defining LocalStack service
- `README.md`: Basic project documentation (currently minimal)

### Development Environment
The project is designed to work with LocalStack, which provides a local AWS cloud environment. The setup binds to localhost (127.0.0.1) for security and uses Docker socket mounting for container management.

## Notes
- This appears to be an early-stage project with infrastructure setup focused on cloud-native development
- No application code is present yet - this is primarily infrastructure and tooling setup
- The project follows cloud-native patterns with containerized development environment