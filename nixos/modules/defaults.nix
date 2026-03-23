{...}: {
  perSystem = {self', ...}: {
    packages.terminal = self'.packages.foot;
    packages.launcher = self'.packages.wlr-which-key;
  };
}
