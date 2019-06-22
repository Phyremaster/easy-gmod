# Debian base image with SteamCMD
FROM cm2network/steamcmd

# DO NOT OVERRIDE THESE
ENV GMODID=4020
ENV GMODDIR=/home/steam/garrysmod
ENV CSSID=232330
ENV CSSDIR=/home/steam/css
ENV TF2ID=232250
ENV TF2DIR=/home/steam/tf2
ENV SERVERCFG=${GMODDIR}/garrysmod/cfg/server.cfg
ENV MOUNTCFG=${GMODDIR}/garrysmod/cfg/mount.cfg

# Environment variables
ENV HOSTNAME="A Garry's Mod Server"
ENV MAXPLAYERS=20
ENV GAMEMODE=sandbox
ENV GAMEMAP=gm_flatgrass
ENV ALLTALK=0
ENV MAXFILESIZE=1024
ENV WORKSHOPID=""
ENV DOWNLOADURL=""
ENV LOADINGURL=""
ENV PASSWORD=""
ENV RCONPASSWORD=""
ENV LOGINTOKEN=""

# Mount other game content
ADD mount.cfg $MOUNTCFG

# Add autoupdate script
WORKDIR ${GMODDIR}
ADD autoupdatescript.txt ./

# Start main script
CMD ./easygmod.sh

# Set up container
EXPOSE 27015/tcp 27015/udp
VOLUME ${GMODDIR} ${CSSDIR} ${TF2DIR}