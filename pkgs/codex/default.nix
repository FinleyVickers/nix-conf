{ fetchurl, lib, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "codex";
  version = "0.128.0";

  src = fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-x86_64-unknown-linux-musl.tar.gz";
    hash = "sha256-iGuF5hGMC0MjRDfKAH++kjYRpTsQPQDg0650rvsg4jo=";
  };

  dontConfigure = true;
  doCheck = false;

  unpackPhase = ''
    runHook preUnpack
    tar -xzf "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 codex-x86_64-unknown-linux-musl "$out/bin/codex"
    runHook postInstall
  '';

  meta = with lib; {
    description = "OpenAI Codex command-line interface";
    homepage = "https://github.com/openai/codex";
    license = licenses.asl20;
    mainProgram = "codex";
    platforms = [ "x86_64-linux" ];
  };
}
