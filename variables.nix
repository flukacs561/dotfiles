rec {
  hostName = "abulafia";
  userName = "lukacsf";
  homeDirectory = "/home/${userName}";
  nixRepo = "${homeDirectory}/code/dotfiles";
  configHome = "${homeDirectory}/.config";
  dataHome = "${homeDirectory}/.local/share";
  bluetooth = false;
  online-mode = true;
  lock-screen = true;
  editor = "hx";
  isEmacs = false;
  isHelix = true;
}
