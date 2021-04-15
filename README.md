===============
instawhore
===============
Cut, add, edit, scale, watermark, and endlogo videos to post on instafuck automatically. A great tool for wasting time, not accomplishing anything, and being a slave to social media. 

> I would rather be free and live in danger than be a slave and live in peace.
	  - Jean Jacques Rousseau

# Requirements
* ffmpeg
* curl
* ftpd (on device)
* nix distro
* some other shit I'm sure

# Installation
```
git clone https://github.com/bubonic/instawhore
```

# Usage
```
YouTube/InstaBitch HIGHlights v4.2.0 (sammy davis sr.)
 
Usage: /home/bubonic/Scripts/highlights.sh [options] -i inputfile -o outputfile
 
Options:                -i <inputfile>
                        -o <outputfile> 
                        -a | --audio <y,n> (default=y)
                        -I | --interlaced <y,n> (default=n) 
                        -p | --parse <y,n> (default=y)
                        -w | --watermark <y,n> (default=n) 
                        -e | --endlogo <y,n> (default=n)
                        -f | --full-match <y,n> (default=n) 
                        -d | --days-ago <n> (default=NULL, useful when combining videos not of today)
                        -D | --duration-file <file>
                        -t | --timestamp-file <file>
                        -P | --preset <veryslow, slow, medium, fast, ultrafast> (default=medium)
                        --scale (up scale highlight to 1080p)
                        --dscale-logo (down scale endlogo from 1080p to 720p)
                        --fps | --frame-rate <fps> (default is fps on inputfile)
                        --encode-fullmatch (useful for bad YouTube or other encodes)
                        --encode-cuts (recommended)
                        --instagram (make the video instgram friendly and upload to device)
                        --pink (use pink endlogo instead of blue)
                        --top-left (apply watermark to top left)
                        --drillroom (apply drillroom watermark instead)
                        --audio-file <mp3> (fullpath of audio file to add to track)
                        --audio-seek <hh:mm:ss> (audio seek time, we will extract the exact amount of time of the highlight)
                        --watermark-file <.png|.jpg> (full path of watermark file to add to video)
                        --logodir <path> (full path of where your endlogo(s) are)
```

### Example
```
~/Scripts/highlights.sh -i fullmatch_04.15.2021.mp4 -o Alcaide_Vs_Thorpe-G3-Highlights -a n -I y -p y -e y -D durations -t timestamps -P ultrafast --encode-cuts --instagram --pink --audio-file "wheretheyat.mp3" --audio-seek 00:00:18
```

**Output**
```
Setting audio parameter....
Setting interlaced parameter....
Setting parse parameter....
Setting endlogo parameter....
Setting durations file....
Setting timestamps file....
Setting preset parameter....
Setting encode cuts parameter....
Setting instgram post method....
Using Pink Endlogo...
Adding audio file: wheretheyat.mp3...
Adding seek time for audiofile: 00:00:18...
FPS: 25.000
A15.mkv
A20.mkv
A29.mkv
A32.mkv
A8.mkv
Albin Ouschan vs Billy Thorpe _ Group Three _ Predator Championship League Pool-y0TK2nPigQs.mkv
Albin Ouschan vs Darren Appleton _ Group Three _ Predator Championship League Pool-LLkL7d5EjQk.mkv
Albin Ouschan vs David Alcaide _ Group Three _ Predator Championship League Pool-A6AKfE2MR3Q-fanart.jpg
Albin Ouschan vs David Alcaide _ Group Three _ Predator Championship League Pool-A6AKfE2MR3Q.mkv
Albin Ouschan vs Kelly Fisher _ Group Three _ Predator Championship League Pool-c9hvzaYA98U.mkv
Albin Ouschan vs Mieszko Fortunski _ Group Three _ Predator Championship League Pool-Ygu69JByN9k.mkv
Albin Ouschan vs Niels Feijen _ Group Three _ Predator Championship League Pool-JRzQqiHwElk.mkv
Albin Ouschan vs Niels Feijen _ Group Three Semi Final _ Predator Championship League Pool-1nb6tR8ykwc.mkv
Alcaide_Vs_Thorpe-G3-Highlights.mp4
Alcaide_Vs_Thorpe-G3-Highlights-watermark.mp4
Billy Thorpe vs Kelly Fisher _ Group Three _ Predator Championship League Pool-QiQBLLv4R14.mkv
Billy Thorpe vs Mieszko Fortunski _ Group Three _ Predator Championship League Pool-Z08TJnYH830.mkv
Billy Thorpe vs Niels Feijen _ Group Three _ Predator Championship League Pool--X36tUpslF4.mkv
Darren Appleton vs Billy Thorpe _ Group Three _ Predator Championship League Pool-5yIjpBQgh7I.mkv
Darren Appleton vs Kelly Fisher _ Group Three _ Predator Championship League Pool-FaC3DrEmyqo.mkv
Darren Appleton vs Niels Feijen _ Group Three _ Predator Championship League Pool-Z0a4rNQxQOU.mkv
David Alcaide vs Billy Thorpe _ Group Three _ Predator Championship League Pool-78i0KKPvovU-fanart.jpg
David Alcaide vs Billy Thorpe _ Group Three _ Predator Championship League Pool-78i0KKPvovU.mkv
David Alcaide vs Billy Thorpe _ Group Three Semi Final _ Predator Championship League Pool-OOsloYZXw5w-fanart.jpg
David Alcaide vs Billy Thorpe _ Group Three Semi Final _ Predator Championship League Pool-OOsloYZXw5w.mkv
David Alcaide vs Darren Appleton _ Group Three _ Predator Championship League Pool-3PoipTcRO-g-fanart.jpg
David Alcaide vs Darren Appleton _ Group Three _ Predator Championship League Pool-3PoipTcRO-g.mkv
David Alcaide vs Kelly Fisher _ Group Three _ Predator Championship League Pool-t4JUAOXNTLo-fanart.jpg
David Alcaide vs Kelly Fisher _ Group Three _ Predator Championship League Pool-t4JUAOXNTLo.mkv
David Alcaide vs Niels Feijen _ Group Three Final _ Predator Championship League Pool-aRwKQdi35js-fanart.jpg
David Alcaide vs Niels Feijen _ Group Three Final _ Predator Championship League Pool-aRwKQdi35js.mkv
Alcaide vs Niels Feijen _ Group Three _ Predator Championship League Pool-In-eux8M-nE-fanart.jpg
David Alcaide vs Niels Feijen _ Group Three _ Predator Championship League Pool-In-eux8M-nE.mkv
Feijen_vs_Fortunski-g3-highlights.mp4
Feijen_vs_Fortunski-g3-highlights-watermark.mp4
fullmatch_04.15.2021.mp4
highlights_03.31.2021-watermark_endlogo_audio.mp4
highlights_03.31.2021-watermark-endlogo.mp4
highlights_03.31.2021-watermark.mkv
highlights_04.15.2021-watermark_endlogo_audio.mp4
highlights_04.15.2021-watermark-endlogo.mp4
highlights_04.15.2021-watermark.mkv
Mieszko Fortunski vs Darren Appleton _ Group Three _ Predator Championship League Pool-M7FAt5ET-cY.mkv
Mieszko Fortunski vs David Alcaide _ Group Three _ Predator Championship League Pool-GXaxCESp0VI-fanart.jpg
Mieszko Fortunski vs David Alcaide _ Group Three _ Predator Championship League Pool-GXaxCESp0VI.mkv
Mieszko Fortunski vs Kelly Fisher _ Group Three _ Predator Championship League Pool-EVM8A4rPNq0.mkv
Niels Feijen vs Kelly Fisher _ Group Three _ Predator Championship League Pool-2T2icls8dgY.mkv
Niels Feijen vs Mieszko Fortunski _ Group Three _ Predator Championship League Pool-OMDMCrCk-Aw.mkv
Done. 
File: fullmatch_04.15.2021.mp4
-----------------Cut = 0------------------------
 TS: 00:02:34 , t: 5    
-----------------Cut = 0------------------------
Encoding cut 0 (without audio)....Done.
i=1   
-----------------Cut = 1------------------------
 TS: 00:18:00 , t: 6    
-----------------Cut = 1------------------------
Encoding cut 1 (without audio)....Done.
i=2   
-----------------Cut = 2------------------------
 TS: 00:37:53 , t: 8    
-----------------Cut = 2------------------------
Encoding cut 2 (without audio)....Done.
i=3   
-----------------Cut = 3------------------------
 TS: 00:38:24 , t: 6    
-----------------Cut = 3------------------------
Encoding cut 3 (without audio)....Done.
i=4   
-----------------Cut = 4------------------------
 TS: 00:40:15 , t: 7    
-----------------Cut = 4------------------------
Encoding cut 4 (without audio)....Done.
i=5   
Creating full highlight clip....Done.
FILE:  highlights_04.15.2021.mkv 
Okay... No watermark then.
FILE: highlights_04.15.2021-watermark.mkv
--------------------------------------------
Selecting PINK endlogo...
--------------------------------------------
Reconfiguring Endlogo...Done.
Adding EndLogo....Done.
FILE: highlights_04.15.2021-watermark-endlogo.mp4
Adding 40 seconds of audio to video... [mp3 @ 0x5583349ef600] Estimating duration from bitrate, this may be inaccurate
[aac @ 0x55dbfb2206c0] Estimating duration from bitrate, this may be inaccurate
Done. 
Padding video for instafuck...[libx264 @ 0x5591f530af40] frame MB size (120x120) > level limit (8192)
[libx264 @ 0x5591f530af40] DPB size (4 frames, 57600 mbs) > level limit (2 frames, 32768 mbs)
[libx264 @ 0x5591f530af40] MB rate (360000) > level limit (245760)
Done. 
Watermarking instafuck video....[libx264 @ 0x55d390ab4d80] frame MB size (120x120) > level limit (8192)
[libx264 @ 0x55d390ab4d80] DPB size (4 frames, 57600 mbs) > level limit (2 frames, 32768 mbs)
[libx264 @ 0x55d390ab4d80] MB rate (360000) > level limit (245760)
[Parsed_movie_0 @ 0x55d390bad500] EOF timestamp not reliable
Done. 
      
Instagram Video: Alcaide_Vs_Thorpe-G3-Highlights-watermark.mp4
Uploading to Pixel C...
Checking if host is alive and port is open: Connection to x.x.x.x 49162 port [tcp/*] succeeded!
Sending file...
################################################################################################################################################################################################################################ 
Done. 
Bye.
```

#### Example 'durations' (file)
```$ cat durations
5
6
8
6
7
```



#### Example 'timestamps' (file)
```$ cat timestamps 
00:02:34
00:18:00
00:37:53
00:38:24
00:40:15
```

Obviously the durations are applied to each timestamp for the cut and edit. 

#### EDIT (instawhore.sh)
Edit the following variables to access your ftp server on your device so the whorevid can be uploaded automatically saving some time of transferring to your device, like 6 seconds. But 6 seconds x 100 videos is 10 minutes. That's basically a smoke break.
```
#EDIT THESE 
HOST="x.x.x.x"
PORT=1729 
USERNAME="octaLSD"
PASSWORD="123 162 151 156 151 166 141 163 141 40 122 141 155 141 156 165 152 141 156 40 141 156 144 40 61 67 62 71"
```

# Notes

Plenty of options, suggest more in the **issues** if you would like to see them. Instagram on some devices requires the video to be padded as it won't scale properly and the upload will look like shit. 'instawhore.sh' can also be used separately, although there is really no point - like everything else. Also, it's nice to have the padding for your Company, Mafia, Prison Gang, or Illegal Enterprise's logo. 

# Donations

## PayPal
Coding is very time consuming and if you are obliged in offering a donation please click on the following PayPal link

[![paypal](https://i.imgur.com/KSkRsgR.png)](https://www.paypal.com/donate?hosted_button_id=6LXBPHPTDDX56)

## Bitcoin
If you wish to remain anonymous and want to donate via Bitcoin, please send any amount to the following address:

**1QC91r396jYffu1VGBn2TiBAMsYFN5aRq2**

## Monero

Or even more anon:

**87WZEYd2gcKjp5JhMS15PmH1HTxr7az5h3EYMVrMmZ5Qjp8n7m2622tW97UfqHYWd4apyVXDPXLeMAzkAYAPs2jSHsVzaTj**




