#!/bin/sh

# Update Garry's Mod
${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${GMODDIR} +app_update ${GMODID} validate +quit

# Update other game content
${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${CSSDIR} +app_update ${CSSID} validate +quit
${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${TF2DIR} +app_update ${TF2ID} validate +quit

# Mount other game content
cp mount.cfg ${MOUNTCFG}

# Edit server config file
touch ${SERVERCFG}
if grep -q 'hostname' ${SERVERCFG}
then
    sed -i 's/hostname.*/hostname "'"${HOSTNAME}"'"/' ${SERVERCFG}
else
    echo "hostname \"${HOSTNAME}\"" >> ${SERVERCFG}
fi
if grep -q 'sv_alltalk' ${SERVERCFG}
then
    sed -i 's/sv_alltalk.*/sv_alltalk '${ALLTALK}'/' ${SERVERCFG}
else
    echo "sv_alltalk ${ALLTALK}" >> ${SERVERCFG}
fi
if grep -q 'net_maxfilesize' ${SERVERCFG}
then
    sed -i 's/net_maxfilesize.*/net_maxfilesize '${MAXFILESIZE}'/' ${SERVERCFG}
else
    echo "net_maxfilesize ${MAXFILESIZE}" >> ${SERVERCFG}
fi
if [ ! -z ${WORKSHOPID} ]
then
    if grep -q 'host_workshop_collection' ${SERVERCFG}
    then
        sed -i 's/host_workshop_collection.*/host_workshop_collection '${WORKSHOPID}'/' ${SERVERCFG}
    else
        echo "host_workshop_collection ${WORKSHOPID}" >> ${SERVERCFG}
    fi
fi
if [ ! -z ${DOWNLOADURL} ]
then
    if grep -q 'sv_downloadurl' ${SERVERCFG}
    then
        sed -i 's/sv_downloadurl.*/sv_downloadurl "'${DOWNLOADURL}'"/' ${SERVERCFG}
    else
        echo "sv_downloadurl \"${DOWNLOADURL}\"" >> ${SERVERCFG}
    fi
    if grep -q 'sv_allowdownload' ${SERVERCFG}
    then
        sed -i 's/sv_allowdownload.*/sv_allowdownload 1/' ${SERVERCFG}
    else
        echo "sv_allowdownload 1" >> ${SERVERCFG}
    fi
    if grep -q 'sv_allowupload' ${SERVERCFG}
    then
        sed -i 's/sv_allowupload.*/sv_allowupload 1/' ${SERVERCFG}
    else
        echo "sv_allowupload 1" >> ${SERVERCFG}
    fi
fi
if [ ! -z ${LOADINGURL} ]
then
    if grep -q 'sv_loadingurl' ${SERVERCFG}
    then
        sed -i 's/sv_loadingurl.*/sv_loadingurl "'${LOADINGURL}'"/' ${SERVERCFG}
    else
        echo "sv_loadingurl \"${LOADINGURL}\"" >> ${SERVERCFG}
    fi
fi
if [ ! -z ${PASSWORD} ]
then
    if grep -q 'sv_password' ${SERVERCFG}
    then
        sed -i 's/sv_password.*/sv_password "'${PASSWORD}'"/' ${SERVERCFG}
    else
        echo "sv_password \"${PASSWORD}\"" >> ${SERVERCFG}
    fi
fi
if [ ! -z ${RCONPASSWORD} ]
then
    if grep -q 'rcon_password' ${SERVERCFG}
    then
        sed -i 's/rcon_password.*/rcon_password "'${RCONPASSWORD}'"/' ${SERVERCFG}
    else
        echo "rcon_password \"${RCONPASSWORD}\"" >> ${SERVERCFG}
    fi
fi
if [ ! -z ${LOGINTOKEN} ]
then
    if grep -q 'sv_setsteamaccount' ${SERVERCFG}
    then
        sed -i 's/sv_setsteamaccount.*/sv_setsteamaccount "'${LOGINTOKEN}'"/' ${SERVERCFG}
    else
        echo "sv_setsteamaccount \"${LOGINTOKEN}\"" >> ${SERVERCFG}
    fi
fi
if ! grep -q 'exec banned_ip.cfg' ${SERVERCFG}
then
    echo "exec banned_ip.cfg" >> ${SERVERCFG}
fi
if ! grep -q 'exec banned_user.cfg' ${SERVERCFG}
then
    echo "exec banned_user.cfg" >> ${SERVERCFG}
fi

# Start the server
exec ${GMODDIR}/srcds_run -autoupdate -steam_dir ${STEAMCMDDIR} -steamcmd_script /home/steam/autoupdatescript.txt -port 27015 -maxplayers ${MAXPLAYERS} -game garrysmod +gamemode ${GAMEMODE} +map ${GAMEMAP}