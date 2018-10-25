#include <stdio.h>

int main() {
  printf("v%d.%d.%d\n",__GNUC__,__GNUC_MINOR__,__GNUC_PATCHLEVEL__);
  return 0;
}
