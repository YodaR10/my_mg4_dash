#!/usr/bin/env bash
set -euo pipefail

# Prepara tag e release GitHub per un canale BETA (MG4 / AAOS).
# Flusso: build APK release -> tag git -> push tag -> (opzionale) GitHub pre-release via gh.
#
# Uso:
#   ./scripts/release_beta.sh <version> <build-number> <beta-number> [--no-build]
#
# Esempi:
#   ./scripts/release_beta.sh 1.1.0 2 1
#     -> build-name 1.1.0-beta.1, build-number 2, tag v1.1.0-beta.1
#
# Prerequisiti:
# - flutter, git nel PATH
# - keystore/firma release configurata in android/app/build.gradle.kts (ora firma debug)
# - per creare la release automaticamente: GitHub CLI `gh` autenticata (`gh auth login`)

usage() {
  echo "Uso: $0 <version> <build-number> <beta-number> [--no-build]" >&2
  echo "  <version>       es. 1.1.0 (senza prefisso v e senza suffisso beta)" >&2
  echo "  <build-number>  intero crescente (versionCode Android), es. 2" >&2
  echo "  <beta-number>   numero progressivo beta, es. 1 -> v<version>-beta.1" >&2
  echo "  --no-build      salta 'flutter build apk', usa l'APK già presente" >&2
  exit 1
}

if [[ $# -lt 3 ]]; then
  usage
fi

VERSION="$1"
BUILD_NUMBER="$2"
BETA_N="$3"
shift 3

NO_BUILD=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-build) NO_BUILD=true ;;
    -h|--help) usage ;;
    *) echo "Argomento non riconosciuto: $1" >&2; usage ;;
  esac
  shift
done

if ! [[ "$BUILD_NUMBER" =~ ^[0-9]+$ ]] || ! [[ "$BETA_N" =~ ^[0-9]+$ ]]; then
  echo "Errore: <build-number> e <beta-number> devono essere interi." >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

BUILD_NAME="${VERSION}-beta.${BETA_N}"
TAG="v${BUILD_NAME}"
APK_SRC="build/app/outputs/flutter-apk/app-release.apk"
OUT_DIR="build/release"
APK_OUT="${OUT_DIR}/my_mg4_dash-${BUILD_NAME}+${BUILD_NUMBER}.apk"

echo "==> Beta release"
echo "    versionName : ${BUILD_NAME}"
echo "    versionCode : ${BUILD_NUMBER}"
echo "    tag         : ${TAG}"
echo

if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "Errore: il tag ${TAG} esiste già." >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Attenzione: working tree non pulito. Verrà taggato il commit HEAD corrente." >&2
  git status --short >&2
  echo >&2
fi

if [[ "$NO_BUILD" == false ]]; then
  echo "==> flutter pub get"
  flutter pub get
  echo "==> flutter build apk --release --build-name=${BUILD_NAME} --build-number=${BUILD_NUMBER}"
  flutter build apk --release --build-name="$BUILD_NAME" --build-number="$BUILD_NUMBER"
else
  echo "==> build saltata (--no-build)"
fi

if [[ ! -f "$APK_SRC" ]]; then
  echo "Errore: APK non trovato in ${APK_SRC}" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"
cp "$APK_SRC" "$APK_OUT"
echo "==> APK pronto: ${APK_OUT}"
echo

echo "==> Creo tag annotato ${TAG} su HEAD ($(git rev-parse --short HEAD))"
git tag -a "$TAG" -m "Beta ${BUILD_NAME} (build ${BUILD_NUMBER})"

echo "==> Push del tag su origin"
git push origin "$TAG"

if command -v gh >/dev/null 2>&1; then
  echo "==> Creo GitHub pre-release e carico l'APK (gh)"
  gh release create "$TAG" "$APK_OUT" \
    --prerelease \
    --title "${TAG} (beta)" \
    --notes "Beta ${BUILD_NAME} (versionCode ${BUILD_NUMBER}) per MG4 (AAOS). Installazione via APK da chiavetta USB."
  echo "==> Release beta pubblicata: ${TAG}"
else
  echo "==> 'gh' non trovato: tag pushato, release NON creata automaticamente."
  echo "    Crea una pre-release su GitHub per il tag ${TAG} e allega:"
  echo "      ${APK_OUT}"
  echo "    Oppure installa gh e riesegui solo la parte di release:"
  echo "      gh release create ${TAG} ${APK_OUT} --prerelease --title \"${TAG} (beta)\" --notes \"...\""
fi
