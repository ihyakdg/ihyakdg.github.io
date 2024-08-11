$AXFUN
import axeron.prop
local verName="V1.1"
local version=11
local pid="[$$]"
local p="[-]"
local fcore="https://fahrez256.github.io/game-storm/full/core.sh"
local id="$(settings get secure android_id)"
local trim_id="${id:0:6}"
log_path="/sdcard/Android/data/${AXERONPKG}/files"
log_file="${log_path}/log.txt"
cd_skiped=false

#echo "full $@"

time_conv() {
  ms=$1

  if [ "$ms" -lt 0 ]; then
      seconds=$(echo "$ms / 1000" | bc)
      echo "${2:-${seconds}s}"
  elif [ "$ms" -lt 60000 ]; then
      # Jika kurang dari 60000 ms, tampilkan dalam detik
      seconds=$(echo "$ms / 1000" | bc)
      echo "${seconds}s"
  elif [ "$ms" -lt 3600000 ]; then
      # Jika kurang dari 3600000 ms, tampilkan dalam menit dan detik
      minutes=$(echo "$ms / 60000" | bc)
      seconds=$(echo "($ms % 60000) / 1000" | bc)
      echo "${minutes}m ${seconds}s"
  elif [ "$ms" -lt 86400000 ]; then
      # Jika kurang dari 86400000 ms, tampilkan dalam jam, menit, dan detik
      hours=$(echo "$ms / 3600000" | bc)
      minutes=$(echo "($ms % 3600000) / 60000" | bc)
      seconds=$(echo "($ms % 60000) / 1000" | bc)
      echo "${hours}h ${minutes}m ${seconds}s"
  else
      # Jika lebih dari atau sama dengan 86400000 ms, tampilkan dalam hari, jam, menit, dan detik
      days=$(echo "$ms / 86400000" | bc)
      hours=$(echo "($ms % 86400000) / 3600000" | bc)
      minutes=$(echo "($ms % 3600000) / 60000" | bc)
      seconds=$(echo "($ms % 60000) / 1000" | bc)
      echo "${days}d ${hours}h ${minutes}m ${seconds}s"
  fi
}

current_time=$(date +%s%3N)
last_time=$(cat "$log_file" 2>/dev/null)
time_diff=$((2700000 - (current_time - last_time)))
converted_time=$(time_conv $time_diff "no cooldown")

case $1 in
  --help | -h )
    storm -x "https://fahrez256.github.io/game-storm/full/help.sh" -fn "help" "$@"
    exit 0
    ;;
  --info | -i )
    echo "┌$pid $name | Information"
    echo "├$p ID: $trim_id"
    echo "└┬$p Version: $verName ($version)"
    echo " ├$p Cooldown: $converted_time"
    echo " └$p Package: ${runPackage:-null}"
    exit 0
    ;;
  --changelogs | -cl )
    storm -x "https://fahrez256.github.io/game-storm/full/changelogs.sh" -fn "changelogs" "$@"
    exit 0
    ;;
  --no-cooldown | -ncd )
    rm -f $log_file
    cd_skiped=true
    shift
    ;;
esac

echo "┌$pid $name | $verName ($version)"
echo "│Thank you for donating, enjoy"
[ $cd_skiped = true ] && echo "├$p Cooldown skiped"
storm -x "$fcore" -fn "fcore" "$@"
