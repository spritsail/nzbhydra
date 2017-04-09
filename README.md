# docker-nzbhydra
Dockerfile for running the NZB Management and downloader NZBHydra. It expects a  volume to store data mapped to /config in the container. Enjoy!  
This dockerfile uses a user with uid 907. Make sure this user has write access to the /config folder.
##Example run command
`docker run -d --restart=always --name NZBHydra -v /host/path/to/config:/config -p 5075:5075 adamant/nzbhydra`
