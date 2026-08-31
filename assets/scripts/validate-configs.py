#!/usr/bin/env python3

"""Validate machine-readable configuration formats used by the repository."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
JSONC_ROOTS = (
    ROOT / "config" / "Code",
    ROOT / "config" / "fastfetch",
    ROOT / "config" / "zed",
)


def is_below(path: Path, parent: Path) -> bool:
    try:
        path.relative_to(parent)
    except ValueError:
        return False
    return True


for path in ROOT.rglob("*.json"):
    if ".git" in path.parts or any(is_below(path, root) for root in JSONC_ROOTS):
        continue
    with path.open("r", encoding="utf-8") as handle:
        json.load(handle)

try:
    import tomllib
except ImportError:
    print("tomllib unavailable; skipping TOML validation")
else:
    for path in ROOT.rglob("*.toml"):
        if ".git" not in path.parts:
            with path.open("rb") as handle:
                tomllib.load(handle)

try:
    import yaml
except ImportError:
    print("PyYAML unavailable; skipping YAML validation")
else:
    for pattern in ("*.yml", "*.yaml"):
        for path in ROOT.rglob(pattern):
            if ".git" not in path.parts:
                with path.open("r", encoding="utf-8") as handle:
                    yaml.safe_load(handle)

print("Configuration syntax validation passed.")
