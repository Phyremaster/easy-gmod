#!/bin/sh

# Update Garry's Mod
${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${GMODDIR} +app_update ${GMODID} validate +quit

# Update other game content
${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${CSSDIR} +app_update ${CSSID} validate +quit
${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${TF2DIR} +app_update ${TF2ID} validate +quit

# Edit server config file
touch ${SERVERCFG}
sed -i '/hostname/!{q1}; {s/hostname.*/hostname "'${HOSTNAME}'"/}' ${SERVERCFG} || echo "hostname \"${HOSTNAME}\"" >> ${SERVERCFG}
sed -i '/sv_alltalk/!{q1}; {s/sv_alltalk.*/sv_alltalk '${ALLTALK}'/}' ${SERVERCFG} || echo "sv_alltalk ${ALLTALK}" >> ${SERVERCFG}
sed -i '/net_maxfilesize/!{q1}; {s/net_maxfilesize.*/net_maxfilesize '${MAXFILESIZE}'/}' ${SERVERCFG} || echo "net_maxfilesize ${MAXFILESIZE}" >> ${SERVERCFG}
if [ ! -z ${WORKSHOPID} ] then
  sed -i '/host_workshop_collection/!{q1}; {s/host_workshop_collection.*/host_workshop_collection '${WORKSHOPID}'/}' ${SERVERCFG} || echo "host_workshop_collection ${WORKSHOPID}" >> ${SERVERCFG}
fi
if [ ! -z ${DOWNLOADURL} ] then
  sed -i '/sv_downloadurl/!{q1}; {s/sv_downloadurl.*/sv_downloadurl "'${DOWNLOADURL}'"/}' ${SERVERCFG} || echo "sv_downloadurl \"${DOWNLOADURL}\"" >> ${SERVERCFG}
  sed -i '/sv_allowdownload/!{q1}; {s/sv_allowdownload.*/sv_allowdownload 1/}' ${SERVERCFG} || echo "sv_allowdownload 1" >> ${SERVERCFG}
  sed -i '/sv_allowupload/!{q1}; {s/sv_allowupload.*/sv_allowupload 1/}' ${SERVERCFG} || echo "sv_allowupload 1" >> ${SERVERCFG}
fi
if [ ! -z ${LOADINGURL} ] then
  sed -i '/sv_loadingurl/!{q1}; {s/sv_loadingurl.*/sv_loadingurl "'${LOADINGURL}'"/}' ${SERVERCFG} || echo "sv_loadingurl \"${LOADINGURL}\"" >> ${SERVERCFG}
fi
if [ ! -z ${PASSWORD} ] then
  sed -i '/sv_password/!{q1}; {s/sv_password.*/sv_password "'${PASSWORD}'"/}' ${SERVERCFG} || echo "sv_password \"${PASSWORD}\"" >> ${SERVERCFG}
fi
if [ ! -z ${RCONPASSWORD} ] then
  sed -i '/rcon_password/!{q1}; {s/rcon_password.*/rcon_password "'${RCONPASSWORD}'"/}' ${SERVERCFG} || echo "rcon_password \"${RCONPASSWORD}\"" >> ${SERVERCFG}
fi
if [ ! -z ${LOGINTOKEN} ] then
  sed -i '/sv_setsteamaccount/!{q1}; {s/sv_setsteamaccount.*/sv_setsteamaccount "'${LOGINTOKEN}'"/}' ${SERVERCFG} || echo "sv_setsteamaccount \"${LOGINTOKEN}\"" >> ${SERVERCFG}
fi
sed -i '/exec banned_ip.cfg/!{q1}' ${SERVERCFG} || echo "exec banned_ip.cfg" >> ${SERVERCFG}
sed -i '/exec banned_user.cfg/!{q1}' ${SERVERCFG} || echo "exec banned_user.cfg" >> ${SERVERCFG}

# Start the server
exec ${GMODDIR}/srcds_run -autoupdate -steamdir ${STEAMCMDDIR} -steamcmd_script ${GMODDIR}/autoupdatescript.txt -port 27015 -maxplayers ${MAXPLAYERS} -game garrysmod +gamemode ${GAMEMODE} +map ${GAMEMAP}