#!/bin/bash

# Validation script for Exercise 1: Basic Git Setup
# This script checks if the student has completed all required configuration

echo "🔍 Validating Exercise 1: Basic Git Setup..."
echo "============================================"

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter for passed checks
passed=0
total=6

# Check 1: User name is set
echo -n "1. Checking user name configuration... "
name=$(git config --global --get user.name 2>/dev/null)
if [[ -n "$name" && "$name" != "Your Full Name" ]]; then
    echo -e "${GREEN}✓ PASS${NC} ($name)"
    ((passed++))
elif [[ "$name" == "Your Full Name" ]]; then
    echo -e "${YELLOW}⚠ WARNING${NC} (Still using placeholder name)"
    ((passed++))
else
    echo -e "${RED}✗ FAIL${NC} (Not configured)"
fi

# Check 2: User email is set
echo -n "2. Checking user email configuration... "
email=$(git config --global --get user.email 2>/dev/null)
if [[ -n "$email" && "$email" != "your.email@example.com" ]]; then
    echo -e "${GREEN}✓ PASS${NC} ($email)"
    ((passed++))
elif [[ "$email" == "your.email@example.com" ]]; then
    echo -e "${YELLOW}⚠ WARNING${NC} (Still using placeholder email)"
    ((passed++))
else
    echo -e "${RED}✗ FAIL${NC} (Not configured)"
fi

# Check 3: Default branch is set to main
echo -n "3. Checking default branch configuration... "
branch=$(git config --global --get init.defaultBranch 2>/dev/null)
if [[ "$branch" == "main" ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
    ((passed++))
else
    echo -e "${RED}✗ FAIL${NC} (Should be 'main', found: '$branch')"
fi

# Check 4: Editor is set
echo -n "4. Checking editor configuration... "
editor=$(git config --global --get core.editor 2>/dev/null)
if [[ -n "$editor" ]]; then
    echo -e "${GREEN}✓ PASS${NC} ($editor)"
    ((passed++))
else
    echo -e "${RED}✗ FAIL${NC} (Not configured)"
fi

# Check 5: Color output is enabled
echo -n "5. Checking color configuration... "
color=$(git config --global --get color.ui 2>/dev/null)
if [[ "$color" == "auto" || "$color" == "true" ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
    ((passed++))
else
    echo -e "${RED}✗ FAIL${NC} (Should be 'auto', found: '$color')"
fi

# Check 6: At least one alias is configured
echo -n "6. Checking for aliases... "
aliases=$(git config --global --get-regexp alias 2>/dev/null | wc -l)
if [[ $aliases -gt 0 ]]; then
    echo -e "${GREEN}✓ PASS${NC} ($aliases aliases found)"
    ((passed++))
else
    echo -e "${RED}✗ FAIL${NC} (No aliases configured)"
fi

echo
echo "============================================"
echo "Results: $passed/$total checks passed"

if [[ $passed -eq $total ]]; then
    echo -e "${GREEN}🎉 Congratulations! All checks passed!${NC}"
    echo "You're ready to move on to Exercise 2."
    exit 0
elif [[ $passed -ge 4 ]]; then
    echo -e "${YELLOW}⚠ Good progress! Please address the remaining issues.${NC}"
    exit 1
else
    echo -e "${RED}❌ More work needed. Please review the exercise instructions.${NC}"
    exit 1
fi
