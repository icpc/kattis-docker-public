#include <iostream>

int main() {
  std::cout << "v" << __GNUC__ << "." << __GNUC_MINOR__ << "." << __GNUC_PATCHLEVEL__ << std::endl;
  return 0;
}
