#!/bin/bash

# Function to check if a directory exists
directory_exists() {
  [ -d "$1" ]
}

# ANSI color codes
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${ORANGE}SIVIUM SCRIPTS | ${PURPLE}Checking build environment...${NC}"


# Check if .pm2 folder does not exist, then install pm2
  if ! directory_exists "$HOME/.pm2"; then
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${PURPLE}Installing pm2...${NC}"
    yarn global add pm2
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${GREEN}pm2 installed successfully.${NC}"
  else
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${GREEN}pm2 is already installed.${NC}"
  fi

  # Check if .bun folder does not exist, then install bun
  if ! directory_exists "$HOME/.bun"; then
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${PURPLE}Installing bun...${NC}"
    curl -fsSL https://bun.sh/install | bash
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${GREEN}bun installed successfully.${NC}"
  else
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${GREEN}bun is already installed.${NC}"
  fi
