{config, ...}: {
  config.global-hm.config = {
    xdg.mimeApps.defaultApplications = config.xdg.mime.defaultApplications;
  };
}
