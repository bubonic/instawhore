#!/bin/bash


if [ $# -lt 2 ]; then
	echo "YouTube/InstaBitch HIGHlights v4.2.0 (sammy davis sr.)"
	echo " "
	echo "Usage: $0 [options] -i inputfile -o outputfile"
	echo " "
	echo "Options:		-i <inputfile>"
	echo "			-o <outputfile> "
	echo "			-a | --audio <y,n> (default=y)"
	echo " 			-I | --interlaced <y,n> (default=n) "
	echo " 			-p | --parse <y,n> (default=y)"
	echo " 			-w | --watermark <y,n> (default=n) "
	echo " 			-e | --endlogo <y,n> (default=n)"
	echo " 			-f | --full-match <y,n> (default=n) "
	echo " 			-d | --days-ago <n> (default=NULL, useful when combining videos not of today)"
	echo " 			-D | --duration-file <file>"
	echo " 			-t | --timestamp-file <file>"
	echo " 			-P | --preset <veryslow, slow, medium, fast, ultrafast> (default=medium)"
	echo " 			--scale (up scale highlight to 1080p)"
	echo " 			--dscale-logo (down scale endlogo from 1080p to 720p)"
	echo " 			--fps | --frame-rate <fps> (default is fps on inputfile)"
	echo " 			--encode-fullmatch (useful for bad YouTube or other encodes)"
	echo " 			--encode-cuts (recommended)"
	echo "			--instagram (make the video instgram friendly and upload to device)"
	echo " 			--pink (use pink endlogo instead of blue)"
	echo " 			--top-left (apply watermark to top left)"
	echo " 			--drillroom (apply drillroom watermark instead)"
	echo " 			--audio-file <mp3> (fullpath of audio file to add to track)"
	echo " 			--audio-seek <hh:mm:ss> (audio seek time, we will extract the exact amount of time of the highlight)"
	echo " 			--watermark-file <.png|.jpg> (full path of watermark file to add to video)"
	echo " 			--logodir <path> (full path of where your endlogo(s) are)"
	echo " "

	exit
fi

days=0
Audio="Y"
parse="Y"
interlaced="N"
watermark="N"
endlogo="N"
fullmatch="N"
preset="medium"
drflag=""
dscale="N"
audiofile=""
audioseek=""
watermarkfile="/home/bubonic/Pictures/Pool Stats Pro/Watermark/PSPWatermark_LLC_6_HR_BLUE-Pool Stats-_multi-color-bar_tagline_videologo.png"
LOGODIR=""

while [ "$#" -gt 0 ]; do
        key=${1}

        case ${key} in
                -a|--audio)
                        echo "Setting audio parameter...."
                        Audio=${2^^}
                        shift
                        shift
                        ;;
		-p|--parse)
                        echo "Setting parse parameter...."
                        parse=${2^^}
                        shift
                        shift
                        ;;
                -d|--days-ago)
                        echo "Setting days parameter...."
                        days=${2}
                        shift
                        shift
                        ;;
                -t|--timestamp-file)
                        echo "Setting timestamps file...."
                        timestampfile=${2}
                        shift
                        shift
                        ;;

                -D|--duration-file)
                        echo "Setting durations file...."
                        durationfile=${2}
                        shift
                        shift
                        ;;
                -I|--interlaced)
                        echo "Setting interlaced parameter...."
                        interlaced=${2^^}
                        shift
                        shift
                        ;;
		-w|--watermark)
                        echo "Setting watermark parameter...."
                        watermark=${2^^}
                        shift
                        shift
                        ;;
		-e|--endlogo)
                        echo "Setting endlogo parameter...."
                        endlogo=${2^^}
                        shift
                        shift
                        ;;
		--fps|--frame-rate)
                        echo "Setting fps parameter...."
                        fps=${2}
                        shift
			shift
                        ;;
		-f|--full-match)
                        echo "Setting fullmatch parameter...."
                        fullmatch=${2^^}
                        shift
                        shift
                        ;;
                -P|--preset)
                        echo "Setting preset parameter...."
                        preset=${2}
                        shift
                        shift
                        ;;
                -o|--output)
                        OFILE=${2}
                        shift
                        shift
                        ;;
                -i|--input)
                        IFILE=${2}
                        shift
                        shift
                        ;;           
		--encode-fullmatch)
                        echo "Setting encode fullmatch parameter...."
                        efm="Y"
                        shift
                        ;;
		--encode-cuts)	
                        echo "Setting encode cuts parameter...."
                        ecuts="Y"
                        shift
                        ;;
                --instagram)
                        echo "Setting instgram post method...."
                        instawhore="Y"
                        shift
                        ;;

		--pink)
                        echo "Using Pink Endlogo..."
                        pink="Y"
                        shift
                        ;;
                --top-left)
                        echo "Setting watermark to top left corner..."
                        topleft="Y"
                        shift
                        ;;
                --scale)
                        echo "Scaling to 1080p..."
                        scale="Y"
                        shift
                        ;;
                --dscale-logo)
                	echo "Downscaling 1080p Logo to 720p...."
                	dscale="Y"
                	shift
                	;;
                --drillroom)
                        echo "Adding drillroom watermark..."
                        DRILLROOM=1
                        shift
                        ;;
                --watermark-file)
                        echo "Adding watermark file: ${2}..."
                        watermarkfile=${2}
                        shift
                        shift
                        ;;
                --logodir)
                        echo "Setting Endlogo directory: ${2}..."
                        LOGODIR=${2}
                        shift
                        shift
                        ;;
                        
                --audio-file)
                        echo "Adding audio file: ${2}..."
                        audiofile=${2}
                        shift
                        shift
                        ;;
                --audio-seek)
			if [ -z "$audiofile" ]; then
        			echo "You must speciify an audio file first, see the --audio-file flag"
                		exit
                	else
                	       echo "Adding seek time for audiofile: ${2}..."
	                        audioseek=${2}
	                fi
                        shift
                        shift
                        ;;
                				
                *)
                        shift
                        ;;
        esac
done

if [ -z "$fps" ]; then
	fps=`mediainfo --Inform="Video;%FrameRate%" "$IFILE"` 
	echo "FPS: $fps"
	sleep 2
fi


Date=`date --date "$days day ago" "+%m.%d.%Y"`
SUBDIR=$Date

cp "$watermarkfile" PSPWatermark_LLC_5_small.png

if [ ! -z "$4" ]; then
	audiofile=$4
fi


mapfile -t FULLMATCHFILES < <(ls -1 | grep -E ".mkv|.mp4|.avi")

reEncodeMatch() {
	echo -ne "Re-encoding file: $IFILE...."
	ffmpeg -hide_banner -loglevel warning -y -i "$IFILE" -vf "yadif=deint=all" -c:v libx264 -crf 13 -c:a aac -b:a 192k -preset $preset -profile:v high -level 4.1 -tune film fullmatch_$SUBDIR.mp4
	IFILE="fullmatch_$SUBDIR.mp4"
	echo "Done."
}

createFullMatch() {
	for file in "${FULLMATCHFILES[@]}"
	do
		echo "file '$file'" >> fullmatchfiles
		echo "$file"
	done


#	echo -n "Would you like to create a fullmatch (y/n): "
#	read answerfm
	answerfm=$fullmatch
	efm=$2
	if [ "${answerfm^^}" == "Y" ]; then
		echo -ne "Creating FullMatch file from all video files..."
		
		if [ "$efm" == "Y" ]; then
			ffmpeg -hide_banner -loglevel warning -safe 0 -y -f concat -i fullmatchfiles -vf "yadif=deint=all" -c:v libx264 -crf 13 -c:a aac -b:a 192k -preset $preset -profile:v high -level 4.1 -tune film fullmatch_$SUBDIR.mp4
		else
			ffmpeg -hide_banner -loglevel warning -safe 0 -y -f concat -i fullmatchfiles -vcodec copy -c:a aac -b:a 192k fullmatch_$SUBDIR.mp4
		fi
	IFILE="fullmatch_$SUBDIR.mp4"
	fi

	echo "Done. "
	echo -e "File: \033[30;106;52m$IFILE\033[0m"
}

watermark_highlight() {
	SUBDIR=`date --date "$days day ago" "+%m.%d.%Y"`
	Audio=$1
	echo -ne "Adding Watermark to Highlights...."
	if [ "$Audio" == "Y" ]; then
		ffmpeg -hide_banner -loglevel warning -y -i highlights_$SUBDIR.mkv -vf "movie=PSPWatermark_LLC_5_small.png [watermark]; [in][watermark] overlay=10:main_h-overlay_h-10 [out]" -crf 13 -c:v libx264 -c:a copy -preset $preset -x264-params vbv-bufsize=24175:vbv-maxrate=20000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 2 -aq-strength .90 -me_range 32 -bf 16 -threads 6 -qcomp .80 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -r $fps highlights_$SUBDIR-watermark.mkv
	else
		ffmpeg -hide_banner -loglevel warning -y -i highlights_$SUBDIR.mkv -vf "movie=PSPWatermark_LLC_5_small.png [watermark]; [in][watermark] overlay=10:main_h-overlay_h-10 [out]" -crf 13 -c:v libx264 -an -preset $preset -x264-params vbv-bufsize=24175:vbv-maxrate=20000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 2 -aq-strength .90 -me_range 32 -bf 16 -threads 6 -qcomp .80 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -r $fps highlights_$SUBDIR-watermark.mkv
	fi
	echo "Done."
	echo -e "FILE: \033[30;106;52mhighlights_$SUBDIR-watermark.mkv\033[0m"

}


top_left_watermark_highlight() {
	Audio=$1
	SUBDIR=`date --date "$days day ago" "+%m.%d.%Y"`
	echo "Adding Top-Left Watermark to Highlights..."
	if [ "$Audio" == "Y" ]; then
		ffmpeg -hide_banner -loglevel warning -y -i highlights_$SUBDIR.mkv -vf "movie=PSPWatermark_LLC_5_small.png [watermark]; [in][watermark] overlay=10:10 [out]" -crf 13 -c:v libx264 -c:a copy -preset $preset -x264-params vbv-bufsize=24175:vbv-maxrate=20000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:aq-sensitivity=10:pbratio=1.20:ipratio=1.40 -aq-mode 2 -aq-strength .90 -me_range 32 -bf 16 -threads 6 -qcomp .80 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -r $fps highlights_$SUBDIR-watermark.mkv
	else
		ffmpeg -hide_banner -loglevel warning -y -i highlights_$SUBDIR.mkv -vf "movie=PSPWatermark_LLC_5_small.png [watermark]; [in][watermark] overlay=10:10 [out]" -crf 13 -c:v libx264 -an -preset $preset -x264-params vbv-bufsize=24175:vbv-maxrate=20000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 2 -aq-strength .90 -me_range 32 -bf 16 -threads 6 -qcomp .80 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -r $fps highlights_$SUBDIR-watermark.mkv
	fi
	echo "Done."
	echo -e "FILE: \033[30;106;52mhighlights_$SUBDIR-watermark.mkv\033[0m"
}

watermark() {
	SUBDIR=`date --date "$days day ago" "+%m.%d.%Y"`
	echo -ne "Adding Watermark to fullmatch..."
	ffmpeg -hide_banner -loglevel warning -y -i "$IFILE" -vf "movie=PSPWatermark_LLC_5_small.png [watermark]; [in][watermark] overlay=10:main_h-overlay_h-10 [out]" -crf 19 -preset $preset -level 4.1 -profile:v high -tune film fullmatch_$SUBDIR-watermark.mp4
	echo "Done."
	echo -e "FILE: \033[30;106;52mfullmatch_$SUBDIR-watermark.mp4\033[0m"
	endlogo fullmatch_$SUBDIR-watermark.mp4

}

createHighlights() {

	answer=$6

	if [ "${answer^^}" == "Y" ]; then

		mapfile -t TIMESTAMPS < <(cat $1)
		mapfile -t DURATIONS < <(cat $2)
		Audio=$3
		interlaced=$4

		i=0
		while [ "$i" -lt "${#TIMESTAMPS[@]}" ]; do
			echo "-----------------Cut = $i------------------------"
			echo " TS: ${TIMESTAMPS[$i]} , t: ${DURATIONS[$i]}    "
			echo "-----------------Cut = $i------------------------"
			if [ "$Audio" == "Y" ]; then
				if [[ "$ecuts" == "Y" ]] || [[ "$scale" == "Y" ]]; then
					if [[ "$scale" == "Y" ]]; then
						echo -ne "Encoding & scaling cut $i..."
						ffmpeg -hide_banner -loglevel warning -y -ss ${TIMESTAMPS[$i]} -i "$IFILE" -vf "scale=-1:1080:flags=lanczos+full_chroma_inp+full_chroma_int+bitexact:param0=3,yadif=deint=all" -c:v libx264 -crf 13 -c:a aac -b:a 192k -preset $preset -x264-params vbv-bufsize=62500:vbv-maxrate=50000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 3 -aq-strength .80 -me_range 32 -bf 16 -threads 6 -qcomp .70 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -r $fps -t ${DURATIONS[$i]} cut-$i-temp.mkv
						echo "Done."
						echo -ne "Padding cut $i..."
						ffmpeg -hide_banner -loglevel warning -y -i cut-$i-temp.mkv -vf "pad=width=1920:height=0:x=(1920-iw)/2:y=0,setdar=1920/1080" -crf 13 -c:v libx264 -c:a copy -preset $preset -x264-params vbv-bufsize=62500:vbv-maxrate=50000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 3 -aq-strength .80 -me_range 32 -bf 16 -threads 6 -qcomp .70 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film cut-$i.mkv
					else				
						echo -ne "Encoding cut $i..."
						ffmpeg -hide_banner -loglevel warning -y -ss ${TIMESTAMPS[$i]} -i "$IFILE" -vf "yadif=deint=all" -c:v libx264 -crf 13 -c:a aac -b:a 192k -preset $preset -x264-params vbv-bufsize=62500:vbv-maxrate=50000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 3 -aq-strength .80 -me_range 32 -bf 16 -threads 6 -qcomp .70 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -r $fps -t ${DURATIONS[$i]} cut-$i.mkv
						echo "Done."
					fi
				else
					echo -ne "Copying cut $i..."
					ffmpeg -hide_banner -loglevel warning -y -ss ${TIMESTAMPS[$i]} -i "$IFILE" -vcodec copy -c:a copy -t ${DURATIONS[$i]} cut-$i.mkv
					echo "Done."
				fi
			else
				if [[ "$ecuts" == "Y" ]]; then
					echo -ne "Encoding cut $i (without audio)...."
					ffmpeg -hide_banner -loglevel warning -y -ss ${TIMESTAMPS[$i]} -i "$IFILE" -vf "yadif=deint=all" -c:v libx264 -crf 13 -an -preset $preset -x264-params vbv-bufsize=62500:vbv-maxrate=50000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 3 -aq-strength .80 -me_range 32 -bf 16 -threads 6 -qcomp .70 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -r $fps -t ${DURATIONS[$i]} cut-$i.mkv
					echo "Done."
				else 
					echo -ne "Copying cut $i (without audio)..."
					ffmpeg -hide_banner -loglevel warning -y -ss ${TIMESTAMPS[$i]} -i "$IFILE" -vcodec copy -an -t ${DURATIONS[$i]} cut-$i.mkv
					echo "Done."
				fi	
			fi
			echo "file 'cut-$i.mkv'" >> cutfiles
			let i++
			echo "i=$i"
		done
	else 
		watermark
		echo "Goodbye!"
		exit
	fi
	echo -ne "Creating full highlight clip...."
	if [ "$Audio" == "Y" ]; then
		if [ "$interlaced" == "Y" ]; then
			#ffmpeg -y -safe 0 -f concat -i cutfiles -vf "yadif=deint=all" -crf 13 -c:v libx264 -c:a aac -b:a 192k -preset veryslow -x264-params vbv-bufsize=24175:vbv-maxrate=20000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:aq-sensitivity=10:pbratio=1.20:ipratio=1.40 -aq-mode 2 -aq-strength .90 -me_range 32 -bf 16 -threads 6 -qcomp .80 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film highlights_$SUBDIR.mkv
			ffmpeg -hide_banner -loglevel warning -y -safe 0 -f concat -i cutfiles -vf "yadif=deint=all" -crf 13 -c:v libx264 -c:a aac -b:a 192k -preset $preset -x264-params vbv-bufsize=24175:vbv-maxrate=20000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 2 -aq-strength .90 -me_range 32 -bf 16 -threads 6 -qcomp .80 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -r $fps highlights_$SUBDIR.mkv
		else
			ffmpeg -hide_banner -loglevel warning -y -safe 0 -f concat -i cutfiles -vcodec copy -acodec copy highlights_$SUBDIR.mkv
		fi
	else
		if [ "$interlaced" == "Y" ]; then
			#ffmpeg -y -safe 0 -f concat -i cutfiles -vf "yadif=deint=all" -crf 13 -c:v libx264 -preset veryslow -x264-params vbv-bufsize=24175:vbv-maxrate=20000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:aq-sensitivity=10:pbratio=1.20:ipratio=1.40 -aq-mode 2 -aq-strength .90 -me_range 32 -bf 16 -threads 6 -qcomp .80 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film highlights_$SUBDIR.mkv
			ffmpeg -hide_banner -loglevel warning -y -safe 0 -f concat -i cutfiles -vf "yadif=deint=all" -crf 13 -c:v libx264 -an -preset $preset -x264-params vbv-bufsize=24175:vbv-maxrate=20000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:pbratio=1.20:ipratio=1.40 -aq-mode 2 -aq-strength .90 -me_range 32 -bf 16 -threads 6 -qcomp .80 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -r $fps highlights_$SUBDIR.mkv
		else
			ffmpeg -hide_banner -loglevel warning -y -safe 0 -f concat -i cutfiles -vcodec copy  highlights_$SUBDIR.mkv
		fi
	fi

	#echo -n "Would you like watermark the highlight clip? (y/n): "
	#read answer
	echo "Done."
	echo -e "FILE: \033[30;106;52m highlights_$SUBDIR.mkv \033[0m"

	answer=$5
	if [ "${answer^^}" == "Y" ]; then
		sleep 2
		if [ "$topleft" == "Y" ]; then
			top_left_watermark_highlight $Audio
			
		else
			watermark_highlight $Audio
		fi


	else
		echo "Okay... No watermark then."
		mv highlights_$SUBDIR.mkv highlights_$SUBDIR-watermark.mkv
	fi
	echo -e "FILE: \033[30;106;52mhighlights_$SUBDIR-watermark.mkv\033[0m"
	
}


endlogo()
{
	MatchFile=$1
	Audio=$2
	answerlogo=$3
	fps=$4
	#echo -n "Would you like to add an endlogo (y/n): "
	#read answerlogo
	#ffmpeg -i $MatchFile -af "volume=enable='between(t,44,45)':volume=0, volume=enable='between(t,4,6)':volume=5" -c:v copy highlights_06.10.2020-watermark2.mkv
	#mv highlights_06.10.2020-watermark2.mkv $MatchFile

	if [ "${answerlogo^^}" == "Y" ]; then
		if [ "$pink" == "Y" ]; then
			echo "--------------------------------------------"
			echo "Selecting PINK endlogo..."
			echo "--------------------------------------------"
			if [ -z "$LOGODIR" ]; then
				LOGODIR="/home/bubonic/Videos/Pool Stats Pro/Animations/Pink Animations/Standard/"
			fi
		else
			echo "--------------------------------------------"
			echo "Selecting BLUE endlogo..."
			echo "--------------------------------------------"
			if [ -z "$LOGODIR" ]; then
				LOGODIR="/home/bubonic/Videos/Pool Stats Pro/Animations/Blue Animations/Intro Package/"
			fi
		fi			
		LOGOFILE=`ls "$LOGODIR" | shuf -n 1`
		LOGO=`echo $LOGOFILE | cut -d "." -f 1`
		LOGOPATH=$LOGODIR$LOGOFILE
		if [ "$dscale" == "Y" ]; then
			echo -ne "Scaling Endlogo to 720p..."	
			ffmpeg -hide_banner -loglevel warning -y -i "$LOGOPATH" -map 0:0 -map 0:1 -vf "scale=-1:720:flags=lanczos+full_chroma_inp+full_chroma_int+bitexact:param0=3" -c:v libx264 -crf 13 -c:a aac -b:a 192k $LOGO.mkv
			echo "Done."
		else
			echo -ne "Reconfiguring Endlogo..."
			ffmpeg -hide_banner -loglevel warning -y -i "$LOGOPATH" -map 0:0 -map 0:1 -c:v copy -c:a aac -b:a 192k $LOGO.mkv
			echo "Done."
		fi
		echo -ne "Adding EndLogo...."
		sleep 3
		echo "file '$MatchFile'" >> waterfiles
		echo "file '$LOGO.mkv'" >> waterfiles
		MFILE=`echo $MatchFile | cut -d '.' -f 1-3`
		if [ "$Audio" == "Y" ]; then
			#ffmpeg -y -safe 0 -f concat -i waterfiles -crf 18 -c:v libx264 -c:a aac -b:a 192k -preset fast -level 4.1 -profile:v high -tune film  $MFILE"_endlogo.mp4"
			 #ffmpeg -i "$MatchFile" -i $LOGO.mkv -filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0]concat=n=2:v=1:a=1[outv][outa]" -map "[outv]" -map "[outa]" -c:v libx264 -crf 13 -preset veryslow -x264-params vbv-bufsize=24175:vbv-maxrate=20000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:aq-sensitivity=10:pbratio=1.20:ipratio=1.40 -aq-mode 2 -aq-strength .90 -me_range 32 -bf 16 -threads 6 -qcomp .80 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -c:a aac -b:a 192k  $MFILE"-endlogo.mp4"
			ffmpeg -hide_banner -loglevel warning -y -i "$MatchFile" -i $LOGO.mkv -filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0]concat=n=2:v=1:a=1[outv][outa]" -map "[outv]" -map "[outa]" -c:v libx264 -crf 13 -preset $preset -profile:v high -level 4.1 -tune film -c:a aac -b:a 192k -r $fps  $MFILE"-endlogo.mp4"
		else
			#ffmpeg -y -safe 0 -f concat -i waterfiles -crf 13 -c:v libx264 -preset veryslow -x264-params vbv-bufsize=24175:vbv-maxrate=20000:keyint=260:subme=11:rc-lookahead=90:no-dct-decimate=1:fast-pskip=0:lookahead_threads=2:b-adapt=2:aq-sensitivity=10:pbratio=1.20:ipratio=1.40 -aq-mode 2 -aq-strength .90 -me_range 32 -bf 16 -threads 6 -qcomp .80 -deblock -3,-3 -psy-rd 1.30,0 -profile:v high -level 4.1 -tune film -an $MFILE"-endlogo.mp4"
			ffmpeg -hide_banner -loglevel warning -y -i "$MatchFile" -i $LOGO.mkv -filter_complex "[0:v:0][1:v:0]concat=n=2:v=1[outv]" -map "[outv]" -c:v libx264 -crf 13 -preset $preset -profile:v high -level 4.1 -tune film -an -r $fps  $MFILE"-endlogo.mp4"
		fi
		echo "Done."
		echo -e "FILE: \033[30;106;52m$MFILE-endlogo.mp4\033[0m"

	fi
	#echo -n "Would you like to add the audio track now (y/n): "
	#read answera
	
	if [[ ! -z "$audiofile" ]] && [[ ! -z "$audioseek" ]]; then
		highDurationMS=`mediainfo --Inform="General;%Duration%" highlights_$SUBDIR-watermark-endlogo.mp4`
		highDurationSEC=$(( highDurationMS / 1000 ))
		echo -n "Adding $highDurationSEC seconds of audio to video... "
		answerseek=$audioseek
		answerdur=$highDurationSEC

		ffmpeg -hide_banner -loglevel warning -y  -i "$audiofile" -ss $answerseek -c:a aac -b:a 256k -t $answerdur audio_edit.aac
		ffmpeg -hide_banner -loglevel warning -y  -i highlights_$SUBDIR-watermark-endlogo.mp4 -i audio_edit.aac -map 0 -c:v copy -map 1 -c:a aac -b:a 256k highlights_$SUBDIR-watermark_endlogo_audio.mp4

	fi

	echo "Done."

}

speedUpHighlights() {
	Audio=$1
	Endlogo=$2
	fps=$3
	#echo -n "Would you like to speed up the track (y/n): "
	#read answerspeed
	answerspeed="N"
	if [ "${answerspeed^^}" == "Y" ]; then
		MINS=`mediainfo highlights_$SUBDIR-watermark.mkv | grep "Duration" | head -1 | cut -d ":" -f 2 | tr -d " " | grep -oE "([0-9]min)" | awk -F "min" '{print $1}'`
		SECS=`mediainfo highlights_$SUBDIR-watermark.mkv | grep "Duration" | head -1 | cut -d ":" -f 2 | tr -d " " | grep -oE "([0-9]{1,2}s)" | awk -F "s" '{print $1}'`
		TTIME=$(( (MINS*60) + SECS ))
		echo "Total time of highlight: $TTIME (s)"
		PTS=`echo 50/$TTIME|bc -l`
		echo "PTS: $PTS"

		echo "Speeding up video..."
		ffmpeg -y -i highlights_$SUBDIR-watermark.mkv -vf "setpts=$PTS*PTS" -c:v libx264 -crf 13 -preset $preset -tune film -profile:v high -level 4.1 highlights_$SUBDIR-watermark_speed.mkv
		
		endlogo highlights_$SUBDIR-watermark_speed.mkv $Audio $Endlogo $fps 

	else
		endlogo highlights_$SUBDIR-watermark.mkv $Audio $Endlogo $fps
	fi
}

if [ "$fullmatch" == "N" ] && [ "$efm" == "Y" ]; then
	reEncodeMatch
else
	createFullMatch $fullmatch $efm
fi

createHighlights $timestampfile $durationfile $Audio $interlaced $watermark $parse
speedUpHighlights $Audio $endlogo $fps

if [[ "$DRILLROOM" -eq 1 ]]; then
	drflag="--drillroom"
fi
rm cutfiles fullmatchfiles waterfiles cut-*
if [ "$instawhore" == "Y" ]; then
	if [ -f "highlights_$SUBDIR-watermark_speed.mkv" ]; then
		/home/bubonic/Scripts/instawhore.sh -i highlights_$SUBDIR-watermark_speed.mkv -o "$OFILE" --preset $preset $drflag
	elif [ -f "highlights_$SUBDIR-watermark_endlogo_audio.mp4" ]; then
		/home/bubonic/Scripts/instawhore.sh -i highlights_$SUBDIR-watermark_endlogo_audio.mp4 -o "$OFILE" --preset $preset $drflag

	elif [ -f "highlights_$SUBDIR-watermark-endlogo.mp4" ]; then
		/home/bubonic/Scripts/instawhore.sh -i highlights_$SUBDIR-watermark-endlogo.mp4 -o "$OFILE" --preset $preset $drflag

	else
		/home/bubonic/Scripts/instawhore.sh -i highlights_$SUBDIR-watermark.mkv -o "$OFILE" --preset $preset $drflag
	fi
fi

