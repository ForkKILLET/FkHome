{
  lib,
  makeWrapper,
  callPackage,
  symlinkJoin,
  stdenv,
  buildFHSEnv,
  writeShellScript,
  # These need overriding if you launch Celeste/Loenn/MiniInstaller from Olympus.
  # Some examples:
  # - null: Use default wrapper.
  # - "": Do not use wrapper.
  # - steam-run: Use steam-run.
  # - "steam-run": Use steam-run command available from PATH.
  # - writeShellScriptBin { ... }: Use a custom script.
  # - ./my-wrapper.sh: Use a custom script.
  # In any case, it can be overridden at runtime by OLYMPUS_{CELESTE,LOENN,MINIINSTALLER}_WRAPPER.
  celesteWrapper ? null,
  loennWrapper ? null,
  miniinstallerWrapper ? null,
  skipHandlerCheck ? false, # whether to skip olympus xdg-mime check, true will override it
}:
let

  olympus-unwrapped = callPackage ./unwrapped.nix { };
  inherit (olympus-unwrapped) version;

  wrapper-to-env =
    wrapper:
    if lib.isDerivation wrapper then
      lib.getExe wrapper
    else if wrapper != null then
      wrapper
    else
      "";

  # When installing Everest, Olympus uses MiniInstaller, which is dynamically linked.
  miniinstaller-fhs = buildFHSEnv {
    pname = "olympus-miniinstaller-fhs";
    inherit version;
    targetPkgs =
      pkgs:
      (with pkgs; [
        icu
        openssl
        dotnet-runtime # Without this, MiniInstaller will install dotnet itself.
      ]);
  };

  miniinstaller-wrapper =
    if miniinstallerWrapper == null then
      (writeShellScript "miniinstaller-wrapper" "exec ${lib.getExe miniinstaller-fhs} -c \"$@\"")
    else
      (wrapper-to-env miniinstallerWrapper);

  olympus-wrapped = stdenv.mkDerivation {
    name = "olympus-wrapped-${version}";
    inherit version;
    inherit (olympus-unwrapped) src;

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${lib.getExe olympus-unwrapped} $out/bin/olympus \
        --set-default OLYMPUS_CELESTE_WRAPPER "${wrapper-to-env celesteWrapper}" \
        --set-default OLYMPUS_LOENN_WRAPPER "${wrapper-to-env loennWrapper}"  \
        --set-default OLYMPUS_MINIINSTALLER_WRAPPER "${miniinstaller-wrapper}" \
        --set-default OLYMPUS_SKIP_SCHEME_HANDLER_CHECK "${if skipHandlerCheck then "1" else "0"}"

      #not sure we need to do this
      install -Dm644 lib-linux/olympus.desktop $out/share/applications/olympus.desktop
    '';
  };
in
symlinkJoin {
  name = "olympus-${version}";

  paths = [
    olympus-wrapped
  ];

  nativeBuildInputs = [ makeWrapper ];

  meta = olympus-unwrapped.meta;
}