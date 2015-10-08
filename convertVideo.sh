#!/bin/sh

startDir=$(pwd)
videoFilesToConvert=${startDir}/videoToConvert.txt
workingDir=${startDir}/files/uploads
uploadsDir=${workingDir}/toConvert/
dest=${workingDir}/videos/`date +%Y`/`date +%m`
tmpDir=$(pwd)/tmp/
lockFile=$(pwd)/lock

touch $lockFile

if [ -e $uploadsDir ]
then
	if [ ! -e $tmpDir ]
	then
		mkdir $tmpDir
	fi
	cd $uploadsDir
	videos=`find -type f -regex ".*/.*\.\(mov\|mp4\|ogv\|webm\)"`
	mv $videos $tmpDir
	cd $tmpDir
	rmdir $uploadsDir
	for video in $videos
	do
		output=`echo $video | cut -f2 -d/`
		echo $output >>$videoFilesToConvert
		out=`echo $output | cut -f1 -d.`
		ext=`echo $output | cut -f2 -d.`
		if [ ! -e $dest/ ]
		then
			mkdir -p $dest
		fi
# ffmpeg -y -i $output -ss 15 -vframes 1 -r 1 -s 640x360 -f image2 $dest/$out.jpg
#		On extrait une image de la vidéo
		(ffmpeg -y -i $output -f image2 -ss 15 -vframes 1 $dest/$out.jpg 2>>${startDir}/convertJpg.log)
#		On convertis la vidéo au format .mp4 en résolution 640x360
		(ffmpeg -y -i $output -b 1500k -vcodec libx264 -preset slow -g 30 -s 640x360 $dest/$out.mp4 2>>${startDir}/convertMp4.log)
#		On convertis la vidéo au format .webm en résolution 640x360
		(ffmpeg -y -i $output -b 1500k -vcodec libvpx -acodec libvorbis -ab 160000 -f webm -g 30 -s 640x360 $dest/$out.webm 2>>${startDir}/convertWebm.log)
#		On convertis la vidéo au format .ogv en résolution 640x360
		(ffmpeg -y -i $output -b 1500k -vcodec libtheora -acodec libvorbis -ab 160000 -g 30 -s 640x360 $dest/$out.ogv 2>>${startDir}/convertOgv.log)
#		On renomme la vidéo originale avec le suffixe _orig pour laisser la possibilité, aux visiteurs qui le veulent, de télécharger la version originale de la vidéo
		mv $output ${dest}/${out}_orig.${ext}
	done
	cd $startDir
	rm $videoFilesToConvert
	sleep 1
#	echo "videoFilesToConvert supprimé avec succès" 2>>${startDir}/convert.log
	rmdir $tmpDir
#	echo "tmpDir supprimé avec succès" 2>>${startDir}/convert.log
	sleep 1
fi

cd $startDir
rm $lockFile
chown -R tuxi:users $workingDir
# echo "lockFile supprimée avec succès" 2>>${startDir}/convert.log
sleep 1
# echo "On quite le script" 2>>${startDir}/convert.log
exit;
