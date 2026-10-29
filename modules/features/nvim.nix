{ self, inputs, config, ... }: {

  flake.homeModules.nvim = { pkgs, ... }: {
    programs.neovim = {
      enable = true;

      # Home Manager writes init.lua with the plugin paths added before this file.
      initLua = builtins.readFile ../../assets/nvim/init.lua;

      plugins = with pkgs.vimPlugins; [
        everforest
        vague-nvim
        marks-nvim
        oil-nvim
        nvim-web-devicons
        (nvim-treesitter.withAllGrammars)
        nvim-treesitter-textobjects
        fzf-lua
        typst-preview-nvim
        csvview-nvim
        nvim-lspconfig
        luasnip
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-nio
        blink-lib
        blink-cmp
        gitsigns-nvim
      ];
    };

    # The config is copied into the store, so changes need a rebuild.
    xdg.configFile = {
      "nvim/lua".source = ../../assets/nvim/lua;
      "nvim/after".source = ../../assets/nvim/after;
    };
  };

}
