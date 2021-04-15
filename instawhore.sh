#!/bin/bash

if [ "$#" -lt 2 ]; then
	echo " "
	echo "InstaVideoPost v0.4.2.0 (billy two cues)"
	echo " "
	echo "Usage: $0 -i <video file> -o output [options]"
	echo " "
	echo "Options:           -p|--preset <preset>  , encoding preset (veryslow, slow, etc.)"
	echo "                   -u|--upload   ,  upload the file"
	echo "			--drillroom (useless) "
	exit
fi

PRESET="medium"
UPLOAD=0

#EDIT THESE
HOST="x.x.x.x"
PORT=1729
USERNAME="octaLSD"
PASSWORD="123 162 151 156 151 166 141 163 141 40 122 141 155 141 156 165 152 141 156 40 141 156 144 40 61 67 62 71"


while [ "$#" -gt 0 ]; do
        key=${1}

        case ${key} in
                -i|--input)
                        FILE=${2}
                        shift
                        shift
                        ;;
                -o|--output)
                        OUTPUT=${2}
                        shift
                        shift
                        ;;
                -p|--preset)
                	PRESET=${2}
                	shift
                	shift
                	;;
                -u|--upload)
                	UPLOAD=1
                	shift
                	;;
     	        --drillroom)
                	DRILLROOM=1
                	shift
                	;;
                *)
                        shift
                        ;;
        esac
done


instasize() { 
	echo -ne "Padding video for instafuck..."	
# Old instapad
#	ffmpeg -hide_banner -loglevel warning -i "$FILE"  -vf "pad=width=0:height=iw*(5/4):x=0:y=((iw*(5/4))-ih)/2" -crf 13 -c:v libx264 -c:a copy -preset $PRESET -x264-params vbv-bufsize=62500:vbv-maxrate=50000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 3 -aq-strength .80 -me_range 32 -bf 16 -threads 6 -qcomp .70 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film "$OUTPUT.mp4"
	ffmpeg -y -hide_banner -loglevel warning -i "$FILE"  -vf "pad=width=0:height=iw:x=0:y=(iw-ih)/2" -crf 13 -c:v libx264 -c:a copy -preset $PRESET -x264-params vbv-bufsize=62500:vbv-maxrate=50000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 3 -aq-strength .80 -me_range 32 -bf 16 -threads 6 -qcomp .70 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film "$OUTPUT.mp4"

	echo "Done."
}



watermark() {
	echo -ne "Watermarking instafuck video...."
	if [[ "$DRILLROOM" -eq 1 ]]; then
		cp "/home/bubonic/Pictures/drillroom/drillroom.png" "Watermark.png"
	else
		cp "/home/bubonic/Pictures/Pool Stats Pro/Watermark/PSPInstagram.png" "Watermark.png"
	fi
	ffmpeg -y -hide_banner -loglevel warning -i "$OUTPUT.mp4" -vf "movie=Watermark.png [watermark]; [in][watermark] overlay=(main_w-overlay_w)/2:(main_h-((main_h - $RESOLUTION)/4))-(overlay_h/2) [out]" -crf 13 -c:v libx264 -c:a copy -preset $PRESET -x264-params vbv-bufsize=62500:vbv-maxrate=50000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 3 -aq-strength .80 -me_range 32 -bf 16 -threads 6 -qcomp .70 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film "$OUTPUT-watermark.mp4"

	echo "Done."
	echo " "
	echo "Instagram Video: $OUTPUT-watermark.mp4"

}

upload() {
	echo "Uploading to Pixel C..."
	echo -ne  "Checking if host is alive and port is open: "
	nc -zv $HOST $PORT
	ncret=$?
	if [[ $ncret -eq 0 ]]; then
		echo "Sending file..."
		echo "$OUTPUT" | grep ".mp4"
		blarg=$?
		if [[ $blarg -eq 0 ]]; then
			echo "$FILE"
			curl --connect-timeout 100 -# -T "$OUTPUT" ftp://$HOST:$PORT --user $USERNAME:$PASSWORD
		else
			curl --connect-timeout 100 -# -T "$OUTPUT-watermark.mp4" ftp://$HOST:$PORT --user $USERNAME:$PASSWORD
		fi
		echo "Done."
		echo "Bye."
	else
		echo "Port is closed. Trying again later."
		exit
	fi	
}

RESOLUTION=`mediainfo --Inform="Video;%Height%" "$FILE"`
if [ "$UPLOAD" -eq "1" ]; then
	upload
	exit
else
	instasize
	watermark
	upload
fi
