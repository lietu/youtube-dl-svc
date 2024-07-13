#!/usr/bin/env bash

#
# CONFIGURATION
#

# Path to the directory to store your downloads in
DOWNLOADS_PATH="/home/lietu/storage/storage/youtube/downloads"

# Path to the file that has the links to download
DOWNLOADS_FILE="/home/lietu/storage/storage/youtube/downloads.txt"
ARCHIVE_FILE="/home/lietu/storage/storage/youtube/downloads_archive.txt"

# Which program to use for downloading
YOUTUBE_DL="yt-dlp"

# What args to give it in addition to the URL
ARGS="
  -R infinite
  --download-archive $ARCHIVE_FILE
  --sponsorblock-mark all
  --sponsorblock-remove sponsor
  -S height:1080
"

#
# SCRIPT LOGIC
#

NEXT_DL=""

# Find a suitable binary
find_youtube_dl() {
    if [[ -z "${YOUTUBE_DL}" ]]; then
        YOUTUBE_DL="$(which youtube-dl)"
    fi
    if [[ -z "${YOUTUBE_DL}" ]]; then
        YOUTUBE_DL="$(which yt-dlp)"
    fi
}

# Try and find the next thing to download
find_next_download() {
    echo "Checking ${DOWNLOADS_FILE} for next download"
    while [[ -z "${NEXT_DL}" ]]; do
        NEXT_DL=$(cat "${DOWNLOADS_FILE}" 2>/dev/null | grep -Ev "^\s*$" | grep -Ev "^\s*#" | head -n1)
        if [[ -z "${NEXT_DL}" ]]; then
            sleep 5
        fi
    done

}

# Download the next video/playlist
download_next() {
    echo "Downloading ${NEXT_DL}"
    while [[ true ]]; do
        "$YOUTUBE_DL" $ARGS "${NEXT_DL}"
        local RETVAL="$?"
        if [[ "${RETVAL}" == "0" ]]; then
            break
        else
            echo "Retrying ${NEXT_DL}..."
            sleep 3
        fi
    done
}

# Clear the downloaded video from the downloads list
remove_download_from_list() {
    TMP=$(mktemp)
    grep -v "${NEXT_DL}" "${DOWNLOADS_FILE}" > "${TMP}"
    mv "${TMP}" "${DOWNLOADS_FILE}"

    NEXT_DL=""
}

# Main logic flow
find_youtube_dl
cd "${DOWNLOADS_PATH}"
while [[ true ]]; do
    find_next_download
    download_next
    remove_download_from_list
done
