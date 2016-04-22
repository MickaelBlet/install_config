result=`ps aux | grep "stop_bruit.sh" | wc -l`
if [ $result != "3" ]; then
	exit
fi

while [ true ]; do
	killall -9 System\ Events 2> /dev/null
	sleep 0.1
done
