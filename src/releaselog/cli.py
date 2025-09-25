"""Simple CLI."""

import sys

from releaselog import __version__
from releaselog.core import show_info


def main():
    """Main entry point."""
    if len(sys.argv) > 1 and sys.argv[1] == "--version":
        print(f"release-log {__version__}")
        return 0

    show_info()
    return 0


if __name__ == "__main__":
    sys.exit(main())
