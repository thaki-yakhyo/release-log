#!/bin/bash

# Release Status Checker
# Usage: ./scripts/check-release-status.sh [commit_threshold]

set -e

COMMIT_THRESHOLD=${1:-10}
REPO_ROOT=$(git rev-parse --show-toplevel)

echo "🔍 Release Status Check"
echo "======================="

# Get latest release tag
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

if [ -z "$LATEST_TAG" ]; then
    COMMIT_COUNT=$(git rev-list --count HEAD)
    echo "📊 No previous releases found"
    echo "📈 Total commits: $COMMIT_COUNT"
else
    COMMIT_COUNT=$(git rev-list --count ${LATEST_TAG}..HEAD)
    echo "📊 Latest release: $LATEST_TAG"
    echo "📈 Commits since release: $COMMIT_COUNT"
fi

echo "🎯 Commit threshold: $COMMIT_THRESHOLD"

# Check if release is needed
if [ "$COMMIT_COUNT" -ge "$COMMIT_THRESHOLD" ]; then
    echo "✅ RELEASE READY! ($COMMIT_COUNT >= $COMMIT_THRESHOLD commits)"

    # Suggest next version
    if [ -z "$LATEST_TAG" ]; then
        NEXT_VERSION="v0.1.0"
    else
        VERSION_WITHOUT_V=${LATEST_TAG#v}
        IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION_WITHOUT_V"

        if [ "$COMMIT_COUNT" -ge 50 ]; then
            NEXT_VERSION="v$((MAJOR + 1)).0.0"
            RELEASE_TYPE="MAJOR"
        elif [ "$COMMIT_COUNT" -ge 20 ]; then
            NEXT_VERSION="v${MAJOR}.$((MINOR + 1)).0"
            RELEASE_TYPE="MINOR"
        else
            NEXT_VERSION="v${MAJOR}.${MINOR}.$((PATCH + 1))"
            RELEASE_TYPE="PATCH"
        fi
    fi

    echo "🏷️  Suggested version: $NEXT_VERSION ($RELEASE_TYPE)"
    echo ""
    echo "🚀 To create release manually:"
    echo "   git tag $NEXT_VERSION"
    echo "   git push origin $NEXT_VERSION"
    echo ""
    echo "🤖 Or trigger automated release:"
    echo "   gh workflow run configurable-commit-release.yml -f force_release=true"

else
    REMAINING=$((COMMIT_THRESHOLD - COMMIT_COUNT))
    echo "⏳ Not ready for release"
    echo "🎯 Need $REMAINING more commits"

    # Show recent commits
    echo ""
    echo "📝 Recent commits:"
    if [ -z "$LATEST_TAG" ]; then
        git log --oneline -5
    else
        git log --oneline ${LATEST_TAG}..HEAD | head -5
    fi
fi

echo ""
echo "📊 Commit type breakdown:"
if [ -z "$LATEST_TAG" ]; then
    RANGE="HEAD"
else
    RANGE="${LATEST_TAG}..HEAD"
fi

FEAT_COUNT=$(git log --oneline $RANGE | grep -c "feat:" || echo "0")
FIX_COUNT=$(git log --oneline $RANGE | grep -c "fix:" || echo "0")
DOCS_COUNT=$(git log --oneline $RANGE | grep -c "docs:" || echo "0")
CHORE_COUNT=$(git log --oneline $RANGE | grep -c "chore:" || echo "0")

echo "   🚀 Features: $FEAT_COUNT"
echo "   🐛 Bug fixes: $FIX_COUNT"
echo "   📚 Documentation: $DOCS_COUNT"
echo "   🔧 Chores: $CHORE_COUNT"
