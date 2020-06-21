#!/bin/sh

set -e

# Build modules.squashfs
eval $(make -s printvars VARS=LINUX_DIR QUOTED_VARS=YES)
if [ -f "${LINUX_DIR}/create_modules_fs.sh" ]; then
  "${LINUX_DIR}/create_modules_fs.sh"
  cp "${LINUX_DIR}/modules.squashfs" "$1"
else
  echo "modules.squashfs not built because ${LINUX_DIR}/create_modules_fs.sh is missing"
fi
