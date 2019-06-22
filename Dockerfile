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
ENV WORKSHOPID
ENV DOWNLOADURL
ENV LOADINGURL
ENV PASSWORD
ENV RCONPASSWORD
ENV LOGINTOKEN

# Install Garry's Mod
RUN ${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${GMODDIR} +app_update ${GMODID} validate +quit

# Install other game content
RUN ${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${CSSDIR} +app_update ${CSSID} validate +quit
RUN ${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${TF2DIR} +app_update ${TF2ID} validate +quit

# Mount other game content
RUN echo "
	\"mountcfg\"
	{
		\"cstrike\"	\"${CSSDIR}/cstrike\"
		\"tf\"	\"${TF2DIR}/tf\"
	}
    " > ${MOUNTCFG}

# Add autoupdate script
WORKDIR ${GMODDIR}
ADD autoupdatescript.txt .

# Start main script
CMD ./easygmod.sh

# Set up container
EXPOSE 27015/tcp 27015/udp
VOLUME ${GMODDIR}