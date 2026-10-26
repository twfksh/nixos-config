{ self, inputs, ... }: {

  flake.nixosModules.shell = { pkgs, ... }: {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Put the curl-installed opencode binary on PATH for interactive shells.
    environment.extraInit = ''
      export PATH="$HOME/.opencode/bin:$PATH"
    '';
  };

}
