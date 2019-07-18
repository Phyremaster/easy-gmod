# Easy Gmod
Garry's Mod servers are typically a pain in the butt to set up correctly. This project aims to change that, with the help of Docker.

Docker is a very useful program that allows you to run all kinds of software in containers (containers are like virtual machines, except they don't emulate the entire computer, so it's way faster). This project can be pulled as a Docker image, which is basically a template for a container.

To use this image, you simply run it with the settings that you want (explained in detail below). These settings allow you to configure most of the important parts of the server without having to deal with the usual, complicated setup process. This image automatically installs and mounts Counter Strike: Source and Team Fortress 2 content. This prevents issues with maps and other addons using resources from those games (which is quite common). Players will still need to install the content on their end to avoid seeing missing textures and errors everywhere.

## How to use this
Do you...
- already know what you're doing and just want to know what the settings are? Scroll down to the **References** section!
- have no clue what you're doing but can't stand the idea of reading? I'm working on a video tutorial.
- have no clue what you're doing and prefer reading a guide? Read on, my friend.

In case you haven't realized yet, you need a Docker installation to use this. On Windows, you can download Docker CE from [the official website](https://hub.docker.com/editions/community/docker-ce-desktop-windows); on most Linux distributions, you should be able to install Docker with something like `sudo apt-get install docker-ce` (or your distribution's equivalent). If you're having difficulties installing Docker CE, go get help somewhere else. I didn't make Docker, so I'm not going to debug it for you. Sorry.

Once you've got Docker installed, you're only one command away from having your own Garry's Mod server (but you probably shouldn't run this command yet - read through the whole guide first, and ignore the fact that I act like you ran the command already). Here's an example command:

```
docker run -p 27015:27015/udp phyremaster/easy-gmod
```

*But... But... How do I run this command?*

**Sigh...** On Windows press `Windows Key` + `R`, type `cmd`, then press `Enter`. Type the command and press `Enter`. Ta-daa. If that doesn't work, try pressing `Ctrl` + `Shift` + `Enter` instead of just `Enter` after typing `cmd`, then click `Yes`. On Linux, open the terminal (try the shortcut `Ctrl` + `T`), type the command, and press `Enter`. If that doesn't work, type the command again, but put `sudo ` before the rest of the command and enter your password if necessary.

Assuming you didn't screw up, you should now have a functional Garry's Mod server. It will take a while to start, especially the first time that you start it. This is because this image does not come with the Garry's Mod server, Counter Strike: Source content, and Team Fortress 2 content preinstalled. Instead, the container validates and either installs or updates the server every time that it is started. While to a casual user that may seem like a really stupid way to have this image work, trust me, there are plenty of really good reasons why I made the image this way from a development perspective. It makes updating smoother, code simpler, images smaller, build times quicker, and programming easier. It might even help me in a legal situation, should one arise.

*Wait, what about the settings? I don't want a 20 player sandbox server on gm_flatgrass called "A Garry's Mod Server"!*

Calm down, buddy. We're getting there. And there are way more settings than that.

## How to change stuff
You remember the command from earlier? That was just an example. A better way to represent the command that you should use to start your Garry's Mod server is this:

```
docker run <options> phyremaster/easy-gmod
```

In this version of the command, you replace the `<options>` part with a list of command line options separated by spaces. Just a heads up: I'm always going to use angle brackets (these things: `<` `>`) to enclose things that you should replace.

*Erm... "Command line options"? What are those?*

Command line options are letters preceded by a single hyphen (like this: `-o`) or strings of text preceded by two hyphens (like this: `--option`). Many command line options, including the vast majority of the ones that I will show you here, are followed by some sort of value (like this: `-o value` or this: `--option value`). When using multiple command line options, you must separate them with spaces (like this: `-o value --options value`). You must also separate these command line options from other parts of the command with spaces (like this: `command -o value file`).

### Setting ports
*What are "ports"?*

Your computer is identified in computer networks by its IP address, a series of number separated by periods (or, in IPv6, colons). A port is an additional number, ranging from 0 to 65535 (which may seem like a random number, but it's significant because it's one less than 2^16, making it the highest number that can be represented by two bytes of binary data), which tells your computer which program to send the information that it receives to.

Docker needs to know which port or ports on your computer it should connect the container to. To tell it this, you use the command line option `-p`. To specify the port used for Garry's Mod, the value of `-p` should be in the format `<port>:27015/udp` where you replace `<port>` with the number of the port that you want to use (the default is `27015`, and you should probably stick with that unless you are planning on running multiple servers on one computer). In most cases, you will also need to port forward whatever port you chose in your router settings. This varies significantly between routers, so I'll just tell you to set both of the ports to whatever port you chose and set it to UDP, not TCP. You can Google the rest.

If you intend to use RCON, you have to do pretty much the same thing again, except this time you use TCP instead of UDP (in both the command line option's value and the router port forwarding settings). You should probably skip the port forwarding for RCON, though; doing so is a security risk, so only do it if you know you will need to access RCON from outside of your local network.

To make your server appear on the multiplayer server list, you need to add yet another `-p` command line option with its value in the format `<port>:27005/udp`, this time replacing `<port>` with the number of a different port (the default is `27005`, and, again, you probably shouldn't change it unless you're running more than one server). You will have to port forward this port the same way that you port forwarded the first port.

You have to include the `-p` command line option for Garry's Mod, even if you're using the default `27015`. If you don't, it won't work. Period.

### Storing the files
Docker containers are virtualized. Because of this, you can't just navigate your way to their files on your computer. This also means that containers lose all of their files when they are stopped. For a Garry's Mod server, both of these things are problems.

Fortunately, Docker provides a way around this with the `-v` command line option. The `-v` command line option requires a value in the format `<volume>:<path>`. In this image, there are three pathes that you can replace `<path>` with: `/home/steam/garrysmod`, `/home/steam/css`, and `/home/steam/tf2` (actually, there is a fourth one, but you should probably just leave it alone). If you can't guess which files are stored in each of those pathes, there is no hope for you.

`<volume>` can be replaced with a valid name for a Docker volume, in which case Docker will store the files from `<path>` in a folder named `<volume>` buried somewhere in your system files. I don't recommend doing that for multiple reasons: it's annoying to navigate to these folders on your filesystem, and Docker volumes have a weird tendency to "run out of space" even if your computer still has plenty of available storage. Instead, I suggest that you replace `<volume>` with the full path to a folder on your computer, which will cause Docker to place the files in `<path>` in the folder that you specify. Linux users must run `chmod 777` on the folder. Please note that `<path>` and `<volume>` must be different for every `-v` command line option that you add.

If you don't specify any `-v` command line options, Docker will automatically assign volumes to all of the pathes that I mentioned above. These randomly assigned volumes have long, random strings of numbers and letters as their names. This will make accessing the server files a massive pain in the butt. You have been warned.

### Naming the conatiner
Giving the container a name may help with managing the server later. To give the container a name (and prevent it from being given a randomly assigned two-word name instead), use the `--name` command line option with the name that you want as the value. The name cannot contain spaces or other special characters.

### Stayin' alive
To make the container automatically restart any time that it stops (for example, due to a crash), include the command line option `--restart always`. If you manually stop the container (not just the Garry's Mod server), this behavior will be overriden and the container will remain stopped until you start it or restart Docker.

If you want the Garry's Mod server to start when your computer starts, just make sure that Docker is configured to start when your computer starts. When Docker starts, it will start all of your containers by default.

### Running in the background
Normally, when you enter the command to run this image, your command prompt or terminal will turn into the server console. If you don't want this and instead want the server to just run silently in the background, just add the `-d` command line option, no value necessary.

Please note that, if you later find that you need to access the server console, you will probably need to use RCON to connect to the server console from the game.

### Environment variables
All of the following settings for the server are set using environment variables, so I should probably just explain environment variables now. For our purposes, environment variables are additional settings that I created to make your life easier. All environment variables are specified through a `-e` command line option with a value in the format `<name>=<value>`. `<name>` is to be replaced with the name of the environment variable (which must be entered exactly as I give it to you and will always be in all capital letters), and `<value>` is to be replaced with whatever you are setting the environment variable to. Got it? Good, now we can continue with the rest of the settings.

Oh, and one final note: you should **never use a backtick** (this little guy: `` ` ``) **in the value of one of these environment variables**. If you do, it will ruin everything. Due to the way the programming for this image works, there must be one ASCII character that cannot be used. I chose the backtick, because I believe it is the symbol that you will need the least.

### Naming the server
You can set the name of your server (as it will appear on the multiplayer server list) with the `HOSTNAME` environment variable. The value should, of course, be set to the name that you want your server to have. If your name contains spaces, put quotes before and after it (like this: `"Server Name"`). If not set, this will default to "A Garry's Mod Server".

### Setting the player limit
To set the maximum number of players who can connect to the server at the same time, use the `MAXPLAYERS` environment variable. The value should be set to the number of players that you want to allow to connect simultaneously (as a number, not spelled out). If not set, this will default to 20 players.

### Setting the gamemode
To set the gamemode for your server, use the `GAMEMODE` environment variable. The value of this environment variable must be set to the exact, official name of a gamemode. Additionally, if you want to run a gamemode other than sandbox (`sandbox`) or Trouble in Terrorist Town (`terrortown`), you must install the gamemode (or the addon containing the gamemode). If you don't specify a gamemode, sandbox will be used by default.

### Setting the map
To set the map that your server will start on, use the `GAMEMAP` environment variable. Similar to setting the gamemode, you must use the exact, official name of the map as the value, and, if you want to use a map other than Flatgrass (`gm_flatgrass`) or Construct (`gm_construct`), you will have to install the map (or addon containing the map). If you don't specify a map, Flatgrass will be used by default.

### Talking between teams
To allow players to talk to players on other teams, set the value of the `ALLTALK` environment variable to the number `1` (this is the default setting). If you want to prevent this, set it to the number `0`.

### Setting the players' download limit
You can prevent players from downloading any file from your server larger than a certain size with the `MAXFILESIZE` environment variable. Set the value of this environment variable to a number representing the size of the largest file you want to let players download in megabytes. If not set, this will default to `1024` (this is the number of megabytes in a gigabyte).

### Installing addons
To install addons to your server, first [create a Garry's Mod Steam Workshop Collection](https://steamcommunity.com/workshop/editcollection/?appid=4000) and put all of the addons that you want to install to your server in the collection. Once the collection is created, copy its ID (the last, long number in the collection's URL). Set the value of the `WORKSHOPID` environment variable to this ID. Your server will automatically install the addons in the collection and keep them up to date (although you can't find them in the server files, for some reason), and players will automatically download these addons from the Steam Workshop (meaning that you do not need to set up FastDL for these addons).

If, for whatever reason, your addon or addons cannot be found in the Steam Workshop (usually the case with custom addons and maps), you must manually place them into the server files. These addons will take a long time for players to download, unless you set up FastDL.

### Speeding up downloads
If you have some content on your server that cannot be downloaded from Steam, it will normally take a very long time to download, because the Source Engine protocol does not handle file transfers very well. To fix this, you can use FastDL, which allows players to automatically download your server's content over HTTPS from a website. To use FastDL, you must have a website containing your server content **with the exact same file structure as your actual Garry's Mod server files**. To set up FastDL, set the value of the `DOWNLOADURL` environment variable to the full link (including the `https://` part) to the folder on your website that contains the contents of the `garrysmod` folder from the default Garry's Mod server file structure. You should probably put quotes around the link.

**You should avoid putting any unnecessary files on your FastDL website.** Doing so will increase download times and could cause a huge security risk.

### Adding a loading screen
To give your server a custom loading screen, set the value of the `LOADINGURL` environment variable to the full link (including the `https://` part) to the webpage that will be your loading screen. You should probably put quotes around the link.

### Making the server private
If you want to make your server private, you can require that players correctly enter a password before connecting. To do this, set the value of the `PASSWORD` environment variable to whatever you want the password to be. If you use special characters, you will need to put quotes around the password.

### Using RCON
**RCON** stands for "**r**emote **con**sole". It allows you to access your server's console from another computer. To enable this, you must set a password. You can set the RCON password with the `RCONPASSWORD` environment variable. Set this environment variable's value to the password that you want to use, with quotes around it if it contains special characters. To use RCON you will also need to set up the RCON port, but that topic has already been covered.

RCON is a pretty big security risk. Avoid it if doing so is a reasonable option. If you must use RCON, **set a very strong password, do not share your password, and avoid port forwarding for RCON if possible**.

### Connecting a Steam Game Server Account
If your Steam account is elligible, you can [create a Steam Game Server Account](https://steamcommunity.com/dev/managegameservers) for your server. This helps you monitor and manage your game server or servers. To link your Garry's Mod server to a Steam Game Server Account, set the value of the `LOGINTOKEN` environment variable to the login token for your Steam Game Server Account.

### Further configuration
*Wait, that's it? What if I want to change a setting that you didn't list here?*

In that case, you will have to manually edit the configuration files. Don't worry about the image overwriting your settings; the script only edits the lines of the configuration files relevant to the environment variables that have been set. To prevent default settings from overwriting your manually-added, custom settings, just set the value or values of the relevant environment variable or variables to the empty string (a pair of quotes with nothing between them, like this: `""`).

Additionally, please note that, to prevent removing manually-added custom settings, **changing an environment variable to the empty string will not remove the relevant part of the configuration files**.

*Wow, I can't believe that you didn't have an environment variable for* `<insert obscure setting>`. *This image sucks.*
  
I'm sorry, did you have to pay for this image? Did you contribute to this project? No? Then shut up and appreciate that I took care of most of the hard stuff for you.

All joking aside, though, if you have feedback or, even better, want to contribute to this project, it is much appreciated. Just don't be a jerk about it.

## Reference
### Ports
- `27015` - TCP - RCON
- `27015` - UDP - SRCDS (the Garry's Mod server)
- `27005` - UDP - SRCDS client port (used for the multiplayer server list)

### Volumes
- `/home/steam/garrysmod` - The Garry's Mod server files
- `/home/steam/css` - The Counter Strike: Source content files
- `/home/steam/tf2` - The Team Fortress 2 content files

### Environment variables (change `server.cfg` or SRCDS launch command)
- `HOSTNAME` - `hostname` - the name of the server, seen in the server list - `"A Garry's Mod Server"`
- `MAXPLAYERS` - `-maxplayers` - the maximum number of concurrent players allowed - `20`
- `GAMEMODE` - `+gamemode` - the gamemode to host - `sandbox`
- `GAMEMAP` - `+map` - the map to host when the server starts - `gm_flatgrass`
- `ALLTALK` - `sv_alltalk` - players can voice chat between teams - `1` (enabled)
- `MAXFILESIZE` - `net_maxfilesize` - the maximum size of file a player can download (in MB) - `1024`
- `WORKSHOPID` - `+host_workshop_collection` - the Workshop ID of the addon collection to host
- `DOWNLOADURL` - `sv_downloadurl`, `sv_allowdownload`, `sv_allowupload` - the link to the FastDL website
- `LOADINGURL` - `sv_loadingurl` - the link to the loading screen webpage
- `PASSWORD` - `sv_password` - the server password, makes server private if set
- `RCONPASSWORD` - `rcon_password` - the RCON password, enables RCON if set
- `LOGINTOKEN` - `+sv_setsteamaccount` - the login token for the Steam Game Server Account

### Automatic file editing (if text or file not already present)
- `exec banned_ip.cfg`, `exec banned_user.cfg` - added to `server.cfg`
- `"cstrike"	"/home/steam/css/cstrike"`, `"tf"	"/home/steam/tf2/tf"` - added to `mount.cfg`
- `server.cfg`, `mount.cfg` - created

## Technical
This project uses `cm2network/steamcmd:root` as a base image ([GitHub](https://github.com/CM2Walki/steamcmd), [Docker Hub](https://hub.docker.com/r/cm2network/steamcmd)) and takes some inspiration from `zennoe/gmod-css-tf2:latest` ([GitHub](https://github.com/Zennoe/docker-gameservers), [Docker Hub](https://hub.docker.com/r/zennoe/gmod-css-tf2)). This project is not affiliated with Facepunch Studios or Valve. I had nothing to do with the creation of the Half Life games, the Counter Strike games, Garry's Mod, or SRCDS. I just built something around those things.

### Project pages
- [GitHub](https://github.com/Phyremaster/easy-gmod)
- [Docker Hub](https://hub.docker.com/r/phyremaster/easy-gmod)
