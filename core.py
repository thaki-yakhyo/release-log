"""Simple core functionality."""

import sys

__version__ = "0.1.0"


def show_info():
    """Show version info."""
    print(f"Release Log v{__version__}")
    print(f"Python: {sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}")
    print(f"Platform: {sys.platform}")


def get_version():
    """Get current version."""
    return __version__
def new_feature():
    return 'awesome feature'
