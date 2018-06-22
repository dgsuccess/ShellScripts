#!/bin/bash

##Usage: nohup sh check_rs_status.sh >resoult.log &

logfile_path=/data/app/logs
logfile_date=`date -d today +%Y-%m-%d`
all_start_line=`wc -l $logfile_path/all.$logfile_date.log|awk '{print $1}'`
load_start_line=`wc -l $logfile_path/monitor.$logfile_date.log|awk '{print $1}'`

while true
do
   sleep 5s
   today=`date -d today +%Y-%m-%d`
   if [[ $today = $logfile_date ]];then
       rs_recive_yc=0
       rs_recive_xt=0
       rs_to_gs=0
       rs_to_cpe=0
       video_to_rs=0
       video_to_ali=0
       all_finish_line=`wc -l $logfile_path/all.$logfile_date.log|awk '{print $1}'`
       load_finish_line=`wc -l $logfile_path/monitor.$logfile_date.log|awk '{print $1}'`

       sed -n ''$all_start_line','$all_finish_line'p' $logfile_path/all.$logfile_date.log >$logfile_path/all.tmp.log
       sed -n ''$load_start_line','$load_finish_line'p' $logfile_path/monitor.$logfile_date.log >$logfile_path/load.tmp.log
       all_start_line=$all_finish_line
       load_start_line=$load_finish_line
       cat /dev/null >$logfile_path/resoult.log
       while read line;do grep 'L:/103.53.211.133:23666] READ:'|awk -v rs_recive_xt="$rs_recive_xt" -v rs_recive_yc="$rs_recive_yc" '{if($NF=="14B") ++rs_recive_xt;else ++rs_recive_yc}END{print "rs_recive_xt:"rs_recive_xt"|""rs_recive_yc:"rs_recive_yc}';done < $logfile_path/all.tmp.log 
       while read line;do grep 'WRITE:'|awk -v rs_to_gs="$rs_to_gs" -v rs_to_cpe="$rs_to_cpe" '{if($(NF-1)=="WRITE:") ++rs_to_gs;else ++rs_to_cpe}END{print "rs_to_gs:"rs_to_gs"|""rs_to_cpe:"rs_to_cpe}';done <$logfile_path/all.tmp.log
       while read line;do egrep 'load original info:|bitrate=N/A speed='|awk -v video_to_rs="$video_to_rs" -v video_to_ali="$video_to_ali" '{if($9=="original") ++video_to_rs;else ++video_to_ali}END{print "video_to_rs:"video_to_rs"|""video_to_ali:"video_to_ali}';done <$logfile_path/load.tmp.log
       #while read line;do egrep 'bitrate=N/A speed='|awk '{print $NF}'|awk -F"=" '{print $2}'|awk -F"x" '{a=a+$1;b++}END{if(b==0) count=0;print "Push_video_speed_avg:"count}';done <load.tmp.log
   else
        logfile_date=$today
   fi
   sleep 5s
   RS_RECIVE_XT=`sed -n '1p' $logfile_path/resoult.log|awk -F"|" '{print $1}'|awk -F":" '{print $2}'`
   RS_RECIVE_YC=`sed -n '1p' $logfile_path/resoult.log|awk -F"|" '{print $2}'|awk -F":" '{print $2}'`
   RS_TO_GS=`sed -n '2p' $logfile_path/resoult.log|awk -F"|" '{print $1}'|awk -F":" '{print $2}'`
   RS_TO_CPE=`sed -n '2p' $logfile_path/resoult.log|awk -F"|" '{print $2}'|awk -F":" '{print $2}'`
   VIDEO_TO_RS=`sed -n '3p' $logfile_path/resoult.log|awk -F"|" '{print $1}'|awk -F":" '{print $2}'`
   VIDEO_TO_ALI=`sed -n '3p' $logfile_path/resoult.log|awk -F"|" '{print $2}'|awk -F":" '{print $2}'`
   echo "<DOCTYPE html lang=\"zh-cn\"><head> <meta charset=\"UTF-8\" /><title>Check RS Status</title><script src=\"d3.v3.min.js\" language=\"JavaScript\"></script><script src=\"liquidFillGauge.js\" language=\"JavaScript\"></script><style>.liquidFillGaugeText { font-family: Helvetica; font-weight: bold; }.pull-left{float: left;}.text-center{text-align: center;}.data{width: 45%;}.data img{width:32%;}.clear{clear: both;}</style></head><body><div class=\"data pull-left text-center\"><svg id=\"fillgauge1\" width=\"40%\" height=\"200\"></svg><p><img src=\"svgimg/01.png\"  /></p></div>        <div class=\"data pull-left text-center\"><svg id=\"fillgauge2\" width=\"40%\" height=\"200\" ></svg><p><img src=\"svgimg/02.png\"  /></p></div><br class=\"clear\" /><div class=\"data pull-left text-center\"><svg id=\"fillgauge3\" width=\"40%\" height=\"200\" ></svg><p><img src=\"svgimg/03.png\"  /></p></div><div class=\"data pull-left text-center\"><svg id=\"fillgauge4\" width=\"40%\" height=\"200\" ></svg><p><img src=\"svgimg/04.png\"  /></p></div><br class=\"clear\" /><div class=\"data pull-left text-center\"><svg id=\"fillgauge5\" width=\"40%\" height=\"200\" ></svg><p><img src=\"svgimg/05.png\"  /></p></div><div class=\"data pull-left text-center\"><svg id=\"fillgauge6\" width=\"40%\" height=\"200\" ></svg><p><img src=\"svgimg/06.png\"  /></p></div><script language=\"JavaScript\">var config0 = liquidFillGaugeDefaultSettings();config0.circleColor = \"#FF7777\";config0.textColor = \"#FF4444\";config0.waveTextColor = \"#FFAAAA\";config0.waveColor = \"#FFDDDD\";config0.circleThickness = 0.1;config0.waveRise = false;config0.textSize = 0.50;config0.textVertPosition = 0.8;config0.valueCountUp = false;config0.waveAnimateTime = 1000;config0.displayPercent = true;var gauge1 = loadLiquidFillGauge(\"fillgauge1\", $RS_RECIVE_YC,config0);var config1 = liquidFillGaugeDefaultSettings();config1.circleColor = \"#FF7777\";config1.textColor = \"#FF4444\";config1.waveTextColor = \"#FFAAAA\";config1.waveColor = \"#FFDDDD\";config1.waveRise = false;config1.circleThickness = 0.1;config1.textSize = 0.50;config1.textVertPosition = 0.8;config1.waveAnimateTime = 1000;config1.valueCountUp = false;config1.displayPercent = true;var gauge2= loadLiquidFillGauge(\"fillgauge2\", $RS_RECIVE_XT, config1);var config2 = liquidFillGaugeDefaultSettings();config2.circleColor = \"#D4AB6A\";config2.textColor = \"#553300\";config2.waveTextColor = \"#805615\";config2.waveColor = \"#AA7D39\";config2.circleThickness = 0.1;config2.waveRise = false;config2.textVertPosition = 0.8;config2.waveAnimateTime = 2000;config2.waveHeight = 0.05;config2.waveCount = 1;config2.valueCountUp = false;config2.textSize = 0.50;config2.displayPercent = true; var gauge3 = loadLiquidFillGauge(\"fillgauge3\", $RS_TO_GS, config2);var config3 = liquidFillGaugeDefaultSettings();config3.circleColor = \"#D4AB6A\";config3.textColor = \"#553300\";config3.waveTextColor = \"#805615\";config3.waveColor = \"#AA7D39\";config3.circleThickness = 0.1;config3.waveRise = false;config3.textSize = 0.50;config3.valueCountUp = false;config3.textVertPosition = 0.8;config3.waveAnimateTime = 2000;config3.waveHeight = 0.05;config3.waveCount = 1;config3.displayPercent = true;var gauge4 = loadLiquidFillGauge(\"fillgauge4\", $RS_TO_CPE, config3);var config4 = liquidFillGaugeDefaultSettings();config4.circleThickness = 0.15;config4.circleColor = \"#808015\";config4.textColor = \"#555500\";config4.waveTextColor = \"#FFFFAA\";config4.waveColor = \"#AAAA39\";config4.textVertPosition = 0.8;config4.waveAnimateTime = 1000;config4.waveHeight = 0.05;config4.waveAnimate = true;config4.waveRise = false;config4.waveHeightScaling = true;config4.waveOffset = 0.25;config4.textSize = 0.50;config4.waveCount = 3;config4.valueCountUp = false;config4.displayPercent = true;var gauge5 = loadLiquidFillGauge(\"fillgauge5\", $VIDEO_TO_RS, config4);var config5 = liquidFillGaugeDefaultSettings();config5.circleThickness = 0.4;config5.circleColor = \"#6DA398\";config5.textColor = \"#0E5144\";config5.waveTextColor = \"#6DA398\";config5.waveColor = \"#246D5F\";config5.textVertPosition = 0.8;config5.waveAnimateTime = 1000;config5.waveHeight = 0.05;config5.waveAnimate = true;config5.waveRise = false;config5.waveHeightScaling = true;config5.waveOffset = 0.25;config5.textSize = 0.50;config5.waveCount = 3;config5.valueCountUp = false;config5.displayPercent = true;var gauge6 = loadLiquidFillGauge(\"fillgauge6\", $VIDEO_TO_ALI, config4);function NewValue(){if(Math.random() > .5){return Math.round(Math.random()*100);} else {return (Math.random()*100).toFixed(1);}}</script><script>function myrefresh() {window.location.reload()} setTimeout('myrefresh()',3000)</script></body></html>" >/usr/local/nginx-rtmp/html/index.html


done