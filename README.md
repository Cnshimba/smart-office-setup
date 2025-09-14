# Smart Office IoT Capstone (Git-ready)

This repository contains a reproducible Docker-based lab for the "Compromising the Smart Office IoT Network" capstone.
It is intended to be run **in an isolated environment** (host-only or isolated VM). Do NOT expose to the internet.

Components:
- docker-compose.yml — lab services (OmniCam, Thermostat, Gateway, Dashboard, Employee)
- vulnerable web app snippets for SQLi and stored XSS
- SMB config and seeded flags
- scripts for recon and DB seeding
- Makefile for convenience
- lab-docs/ with student & instructor materials

Usage (basic):
1. Copy this repo into your Kali VM (scp, wget, or git clone after you push it to your Git host).
2. (Optional) Inspect files, then run `make seed` && `make up`.
3. `make logs` to follow service logs.

Safety: Keep the Docker network internal-only. Do not map service ports to a public interface.

