"""Simple CLI."""

import sys

from core import get_version, show_info


def main():
    """Main entry point."""
    if len(sys.argv) > 1 and sys.argv[1] == "--version":
        print(f"release-log {get_version()}")
        return 0

    show_info()
    return 0


if __name__ == "__main__":
    sys.exit(main())
