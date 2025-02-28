{
  lib,
  nakama-godot,
  stdenv,
  godot_4,
  fontconfig,
  copyDesktopItems,
  export_templates,
  plane-spheres-materials-tar,
  pname,
  version,
  src,
  preset,
  desktopItems ? [],
  exportMode ? "release", # release / debug / pack
  exportTemplates ? export_templates, # absolute path to the nix store
}: let
  meta.mainProgram = pname;
  godot-build = stdenv.mkDerivation rec {
    inherit pname version src desktopItems;

    buildInputs = [
      copyDesktopItems
      godot_4
    ];

    postPatch = ''
      patchShebangs scripts
    '';

    buildPhase = ''
      runHook preBuild

      export HOME=$TMPDIR

      # Remove custom_template path if it doesn't point to the nix store
      sed -i -e \
        '/custom_template/!b' -e '/\/nix\/store/b' -e 's/"[^"]*"/""/g' -e 't' \
        export_presets.cfg

      mkdir -p /build/.local/share/godot/export_templates/

      ln -s ${exportTemplates} /build/.local/share/godot/export_templates/4.3.stable

      # PlaneSpheres expects assets at this location, eg. for textures
      ln -s ${plane-spheres-materials-tar}/store/*source/ /build/game/materials

      mkdir -p /build/game/addons

      # Godot requires that the add on files are physically copied over
      cp -r ${nakama-godot}/addons/com.heroiclabs.nakama /build/game/addons

      mkdir -p $out/share/${pname}
      godot4 --headless --export-${exportMode} "${preset}" \
        $out/share/${pname}/${pname}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      platform=$(awk -F'=' '
      $1 == "name" && $2 == "\"${preset}\"" {
      getline;
      if ($1 == "platform") {
      gsub(/"/, "", $2);
      print $2;
      exit;
      }
      }' export_presets.cfg)


      mkdir -p $out/bin
      ln -s $out/share/${pname}/${pname} $out/bin

      if [ "$platform" == "Linux/X11" ]; then
      patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 \
      $out/share/${pname}/${pname}
      elif [ "$platform" == "Windows Desktop" ]; then
      mv $out/share/${pname}/${pname} $out/share/${pname}/${pname}.exe
      fi

      runHook postInstall
    '';
  };
in
  godot-build
