#!/bin/bash

# ANSI color codes
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if the Git repository is up to date
is_git_up_to_date() {
  git remote update &>/dev/null
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse @{u})
  BASE=$(git merge-base @ @{u})

  if [ $LOCAL = $REMOTE ]; then
    return 0
  elif [ $LOCAL = $BASE ]; then
    return 1
  else
    return 2
  fi
}

# Git actions: reset and pull if the directory is a git repository
if [[ -d .git ]]; then
  if is_git_up_to_date; then
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${GREEN}Project core is already up to date.${NC}"
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${YELLOW}Passing preparing app update.${NC}"
    SKIP_UPDATE=true
  else
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${YELLOW}Updating project core from repo...${NC}"
    git reset --hard
    git pull
  fi
fi

# Run subsequent steps if not skipped
if [[ -z "$SKIP_UPDATE" ]]; then
  echo -e "${ORANGE}SIVIUM SCRIPTS | ${YELLOW}Setting file permissions...${NC}"
  chmod +x ./preinstall.sh
  echo -e "${ORANGE}SIVIUM SCRIPTS | ${GREEN}DONE${NC}"

  # Check if yarn.lock does not exist, then create it
  if [ ! -f "yarn.lock" ]; then
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${YELLOW}yarn.lock does not exist. Creating...${NC}"
    yarn install 2> >(grep -v warning 1>&2)
    echo -e "${ORANGE}SIVIUM SCRIPTS | ${GREEN}DONE${NC}"
  fi

  echo -e "${ORANGE}SIVIUM SCRIPTS | ${PURPLE}Preparing dependencies...${NC}"
  yarn --frozen-lockfile 2> >(grep -v warning 1>&2)
  echo -e "${ORANGE}SIVIUM SCRIPTS | ${GREEN}DONE${NC}"

  echo -e "${ORANGE}SIVIUM SCRIPTS | ${PURPLE}Building files...${NC}"
  #NODE_ENV=production yarn build
  echo -e "${ORANGE}SIVIUM SCRIPTS | ${GREEN}DONE${NC}"
fi

echo -e "${ORANGE}SIVIUM SCRIPTS | ${PURPLE}Starting stapi server...${NC}"
# Run production build
yarn production

# Monitor with pm2
echo -e "${ORANGE}SIVIUM SCRIPTS | ${PURPLE}Monitoring with PM2...${NC}"
echo -e "${ORANGE}SIVIUM SCRIPTS | ${GREEN}Process started. Monitoring with PM2.${NC}"
yarn monit

# Additional messages or actions can be added as per your requirements.