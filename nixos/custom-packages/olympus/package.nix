# From <https://github.com/Petingoso/nixpkgs/blob/olympus/pkgs/by-name/ol/olympus/package.nix>

{
  lib,
  fetchFromGitHub,
  fetchzip,
  buildFHSEnv,
  buildDotnetModule,
  luajitPackages,
  sqlite,
  libarchive,
  curl,
  mono,
  love,
  xdg-utils,
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
  lua_cpath =
    with luajitPackages;
    lib.concatMapStringsSep ";" getLuaCPath [
      (buildLuarocksPackage {
        pname = "lsqlite3";
        version = "0.9.6-1";
        src = fetchzip {
          url = "http://lua.sqlite.org/index.cgi/zip/lsqlite3_v096.zip";
          hash = "sha256-Mq409A3X9/OS7IPI/KlULR6ZihqnYKk/mS/W/2yrGBg=";
        };
        buildInputs = [ sqlite.dev ];
      })

      lua-subprocess
      nfd
    ];

  # When installing Everest, Olympus uses MiniInstaller, which is dynamically linked.
  miniinstaller-fhs = buildFHSEnv {
    name = "olympus-miniinstaller-fhs";
    targetPkgs =
      pkgs:
      (with pkgs; [
        icu
        openssl
        dotnet-runtime # Without this, MiniInstaller will install dotnet itself.
      ]);
  };

  wrapper-to-env =
    wrapper:
    if lib.isDerivation wrapper then
      lib.getExe wrapper
    else if wrapper != null then
      wrapper
    else
      "";

  miniinstaller-wrapper =
    if miniinstallerWrapper == null then
      (writeShellScript "miniinstaller-wrapper" "${miniinstaller-fhs}/bin/${miniinstaller-fhs.name} -c \"$@\"")
    else
      (wrapper-to-env miniinstallerWrapper);

  pname = "olympus";
  phome = "$out/lib/${pname}";
  # The following variables are to be updated by the update script.
  version = "24.11.23.03";
  buildId = "4420"; # IMPORTANT: This line is matched with regex in update.sh.
  rev = "a3792e0c85f3ad7a3029a6a66ca8288aa6f58ae4";

in
buildDotnetModule {
  inherit pname version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "EverestAPI";
    repo = "Olympus";
    fetchSubmodules = true; # Required. See upstream's README.
    hash = "sha256-UPAn9Rbm2IlxMJ/O69WXHugIc+22w+B5i6iLkCcsfQ8=";
  };

  nativeBuildInputs = [
    libarchive # To create the .love file (zip format).
  ];

  nugetDeps = ./deps.nix;
  projectFile = "sharp/Olympus.Sharp.csproj";
  executables = [ ];

  # See the 'Dist: Update src/version.txt' step in azure-pipelines.yml from upstream.
  preConfigure = ''
    echo ${version}-nixos-${buildId}-${builtins.substring 0 5 rev} > src/version.txt
  '';

  # Hack Olympus.Sharp.bin.{x86,x86_64} to use system mono.
  # This was proposed by @0x0ade on discord.gg/celeste.
  # https://discord.com/channels/403698615446536203/514006912115802113/827507533962149900
  postBuild = ''
    dotnet_out=sharp/bin/Release/net452
    dotnet_out=$dotnet_out/$(ls $dotnet_out)
    makeWrapper ${lib.getExe mono} $dotnet_out/Olympus.Sharp.bin.x86 \
      --add-flags ${phome}/sharp/Olympus.Sharp.exe
    cp $dotnet_out/Olympus.Sharp.bin.x86 $dotnet_out/Olympus.Sharp.bin.x86_64
  '';

  # The script find-love is hacked to use love from nixpkgs.
  # It is used to launch Loenn from Olympus.
  # I assume --fused is so saves are properly made (https://love2d.org/wiki/love.filesystem).
  preInstall = ''
    mkdir -p ${phome}
    makeWrapper ${lib.getExe love} ${phome}/find-love \
      --add-flags "--fused"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${phome}/find-love $out/bin/olympus \
      --prefix LUA_CPATH ";" "${lua_cpath}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ curl ]}" \
      --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --set-default OLYMPUS_MINIINSTALLER_WRAPPER "${miniinstaller-wrapper}" \
      --set-default OLYMPUS_CELESTE_WRAPPER "${wrapper-to-env celesteWrapper}" \
      --set-default OLYMPUS_LOENN_WRAPPER "${wrapper-to-env loennWrapper}" \
      --set-default OLYMPUS_SKIP_SCHEME_HANDLER_CHECK ${if skipHandlerCheck then "1" else "0"} \
      --add-flags ${phome}/olympus.love
    bsdtar --format zip --strip-components 1 -cf ${phome}/olympus.love src

    dotnet_out=sharp/bin/Release/net452
    dotnet_out=$dotnet_out/$(ls $dotnet_out)
    install -Dm755 $dotnet_out/* -t ${phome}/sharp

    runHook postInstall
  '';

  postInstall = ''
    install -Dm644 lib-linux/olympus.desktop $out/share/applications/olympus.desktop
    install -Dm644 src/data/icon.png $out/share/icons/hicolor/128x128/apps/olympus.png
    install -Dm644 LICENSE $out/share/licenses/${pname}/LICENSE
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cross-platform GUI Everest installer and Celeste mod manager";
    homepage = "https://github.com/EverestAPI/Olympus";
    downloadPage = "https://everestapi.github.io/#olympus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ulysseszhan
      petingoso
    ];
    mainProgram = "olympus";
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.aarch; # We explicitly copy and wrap x86. possibly able to be done platform agnostic
  };
}