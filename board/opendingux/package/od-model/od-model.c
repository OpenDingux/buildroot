#define _GNU_SOURCE

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  const char sysfs_path[] = "/sys/firmware/devicetree/base/compatible";
  const int fd = open(sysfs_path, O_RDONLY);
  if (fd == -1) {
    perror(sysfs_path);
    exit(EXIT_FAILURE);
  }
  char buf[128];
  const ssize_t len = read(fd, buf, sizeof(buf) - 1);
  if (len <= 0) {
    perror(sysfs_path);
    exit(EXIT_FAILURE);
  }

  // The string looks like this:
  // ylm,rg99\0ingenic,jz4725b\0
  // Print the part before the first \0:
  char *end = memchr(buf, 0, len);
  if (end == NULL) end = &buf[len];
  *end = '\n';

  write(STDOUT_FILENO, buf, end - buf + 1);
  close(fd);
  return 0;
}
