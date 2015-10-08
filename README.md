# Docker-encodeVideo
Start a container with ffmpeg and a script for encoding videos for a website.

# Usage
To build it

    `docker build -t tuxi/ffmpeg .`

Go to the webroot directory on the webserver and run it.

To run it

    `docker run -d --name encodeVideo -v $(pwd):/var/www tuxi/ffmpeg`
