{...}: {
  perSystem = {self', ...}: {
    packages.terminal = self'.packages.foot;
  };
}
