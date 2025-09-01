# Setup for Discord Requesterr bot (Ruedi)
To allow users without direct access to the NAS / Plex setup to still download files, Ruedi was born! It uses the [requesterr](https://github.com/thomst08/requestrr) discord bot to send requests to sonarr / radarr.

# Setup:
The initial setup of Ruedi was (probably, dont know anymore) done via the default docker run command as found in the [documentation](https://github.com/thomst08/requestrr?tab=readme-ov-file#docker-set-up--start)

```sh
    docker run -d \
      --name requestrr \
      -p 4545:4545 \
      -v /var/lib/download/requestrr/config:/root/config \
      --restart=unless-stopped \
      thomst08/requestrr
```

## Config path:
You can find the resulting config file here:
> /var/lib/download/requestrr/config/settings.json