{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.system.sshd;

  inherit (config.user) home;
  sshdTmpDirectory = "${home}/sshd-tmp";
  sshdDirectory = "${home}/sshd";
  port = 8022;

  getSSH = lib.getExe' pkgs.openssh;
in
{
  options.system.sshd = {
    enable = lib.mkEnableOption "SSHD";

    pathToPubKey = lib.mkOption {
      readOnly = true;
      type = lib.types.path;
      description = "The public key that can access this device";
    };
  };

  config = lib.mkIf cfg.enable {
    build.activation.sshd = ''
      $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${home}/.ssh"
      $DRY_RUN_CMD cat ${cfg.pathToPubKey} > "${home}/.ssh/authorized_keys"

      if [[ ! -d "${sshdDirectory}" ]]; then
        $DRY_RUN_CMD rm $VERBOSE_ARG --recursive --force "${sshdTmpDirectory}"
        $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${sshdTmpDirectory}"

        $VERBOSE_ECHO "Generating host keys..."
        $DRY_RUN_CMD ${getSSH "ssh-keygen"} -t rsa -b 4096 -f "${sshdTmpDirectory}/ssh_host_rsa_key" -N ""

        $VERBOSE_ECHO "Writing sshd_config..."
        $DRY_RUN_CMD echo -e "HostKey ${sshdDirectory}/ssh_host_rsa_key\nPort ${toString port}\n" > "${sshdTmpDirectory}/sshd_config"

        $DRY_RUN_CMD mv $VERBOSE_ARG "${sshdTmpDirectory}" "${sshdDirectory}"
      fi
    '';

    environment.packages = [
      (pkgs.wirters.writeBashBin "sshd-start" ''
        echo "Starting sshd in non-daemonized way on port ${toString port}"
        ${getSSH "sshd"} -f "${sshdDirectory}/sshd_config" -D
      '')
    ];
  };
}
