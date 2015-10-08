#!/bin/bash

startDir=$(pwd)
workingDir=${startDir}/files/uploads
uploadsDir=${workingDir}/toConvert/
tmpDir=$(pwd)/tmp/
lockFile=$(pwd)/lock
videoFilesToConvert=${startDir}/videoToConvert.txt
dest=${workingDir}/videos/`date +%Y`/`date +%m`

while true;
do
  if [ ! -e $lockFile ]
  then
    echo "Le fichier de verrouillage n'est pas présent, on vérifie si le dossier toConvert est présent"
    if [ -s $uploadsDir ]
    then
#      echo "Le dossier toConvert existe, on peu lancer les conversions"
      touch $lockFile
      
      if [ -e $uploadsDir ]
      then
        if [ ! -e $tmpDir ]
        then
          mkdir $tmpDir
        fi
        cd $uploadsDir
        
        videos=`find -type f -regex ".*/.*\.\(mov\|mp4\|ogv\|webm\)"`
        sleep 2
        
        mv $videos $tmpDir &&
        sleep 2
        cd $tmpDir &&
      	rmdir $uploadsDir &&
      	sleep 2
      	for video in $videos
      	do
          output=`echo $video | cut -f2 -d/`
          
          out=`echo $output | cut -f1 -d.`
          ext=`echo $output | cut -f2 -d.`
          
          if [ ! -e $dest/ ]
          then
    	      mkdir -p $dest
          fi
#          echo "on est dans le répertoire"
#          echo $(pwd)
#          echo "Et on commence par créer l'image"
#          date
          ffmpeg -y -i $output -f image2 -ss 15 -vframes 1 $dest/$out.jpg &&
#          echo "on on chown le working dir"
          chown -R 1000:www-data $workingDir &&
#          date
#          echo "on continu par le mp4"
          sleep 2
#          date
          ffmpeg -y -i $output -b:v 1500k -vcodec libx264 -preset slow -g 30 -s 640x360 $dest/$out.mp4 &&
#          echo "on on chown le working dir"
          chown -R 1000:www-data $workingDir &&
#          date
#          echo "on continu par le webm"
          sleep 2
#          date
          ffmpeg -y -i $output -b:v 1500k -vcodec libvpx -acodec libvorbis -ab 160000 -f webm -g 30 -s 640x360 $dest/$out.webm &&
#          echo "on on chown le working dir"
          chown -R 1000:www-data $workingDir &&
#          date
#      		echo "c'est fini on mv les files"
      		sleep 2 &&
      		mv $output ${dest}/${out}_orig.${ext} &&
      		sleep 2
      	done
#      	echo "on cd dans le start dir"
      	cd $startDir &&
#      	echo "on rm le fichier videoFilesToConvert"
      	rm $videoFilesToConvert &&
#        echo "sleep 2"
      	sleep 2 &&
#      	echo "on rmdir le dossier temporaire"
      	rmdir $tmpDir &&
#        echo "sleep 1"
      	sleep 1
      fi
      cd $startDir &&
#      echo "on rm le lock file"
      rm $lockFile &&
#      echo "lockFile supprimée avec succès" &&
#      echo "on on chown le working dir"
      chown -R 1000:www-data $workingDir
#      echo "Fin du script"
    fi
  fi
  echo "sleep 10"
  sleep 10
#	Faire un système de log qui affiche l'heure de début et de fin, le verbose de chaque commande importante et m'envoie un mail lorsque tout est terminé, pour avoir un suivie des eventuelles erreurs et les corriger
done
