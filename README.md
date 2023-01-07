# Service for youtube-dl

Quick tool to run `youtube-dl` (or `yt-dlp`) as a service, monitoring a simple text file for links to videos or
playlists to download, and then downloading them one by one.

## Quick setup with systemd

1) Download the `youtube-dl-svc.sh` and `youtube-dl-svc.service`, e.g. by cloning the repo.
2) Edit `youtube-dl.svc.sh` to configure your `DOWNLOADS_PATH`, `DOWNLOADS_FILE`, `YOUTUBE_DL` and `ARGS` as necessary. 
    Check out the options for [youtube-dl](https://github.com/ytdl-org/youtube-dl/blob/master/README.md#options) and
    [yt-dlp](https://github.com/yt-dlp/yt-dlp#usage-and-options) to configure `ARGS` to your liking.
3) Edit `youtube-dl-svc.service` to point to the correct path to `youtube-dl-svc.sh` and use the correct `User` & `Group`
4) Symlink/copy the `.service` file to `/etc/systemd/system/`, e.g.:
    ```bash
    sudo -i
    cd /etc/systemd/system
    ln -s /home/USERNAME/youtube-dl-svc/youtube-dl-svc.service .
    ```
5) Refresh systemd configuration, enable and start the service
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable youtube-dl-svc
   sudo systemctl start youtube-dl-svc
   ```

## DOWNLOADS_FILE format

The file in `DOWNLOADS_FILE` is expected to be rather simple. Empty lines and lines beginning with `#` are skipped.
Other lines are expected to be URLs to be passed to `youtube-dl`/`yt-dlp`, so just paste direct links to Youtube videos
or playlists into it.

Example of what you can do:

```markdown
# Microphone reviews
https://www.youtube.com/watch?v=VinGvXbIaEY&list=PLsbiTKk7c_YBWhypXqjgSmzkUDSMR4_Ex
https://www.youtube.com/watch?v=rn-LTHcPfYM&list=PLsbiTKk7c_YCJc2Czbd45Croyiq0Ga-qH

# Documentaries
https://www.youtube.com/playlist?list=PL64ScZt2I7wHAN7Zs_hUopsqPLSOV9-R1

# Tech
https://www.youtube.com/watch?v=e7DjJR3zpCw
https://www.youtube.com/watch?v=60yFji_GKak
```

These URLs are then passed one by one to the downloader, and once the download completes successfully it is removed from
the file.

The file is not locked, so as long as your editor can notice when the file has been externally changed and will update
the contents it's pretty safe to just keep it open and add links to it when you want.


# License

This code is licensed under the [BSD 3-clause license](./LICENSE). In short that means I take no responsibility over 
your use of it, and you are free to improve on it on your own. I may consider approving Pull Requests for reasonable
improvements.


# Financial support

This project has been made possible thanks to [Cocreators](https://cocreators.ee) and [Lietu](https://lietu.net). You
can help us continue our open source work by supporting us on [Buy me a coffee](https://www.buymeacoffee.com/cocreators)
.

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/cocreators)
