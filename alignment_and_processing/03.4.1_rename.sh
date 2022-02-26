for file in `ls resource/scattered_calling_intervals`
do
	mv resource/scattered_calling_intervals/${file}/scattered.interval_list  resource/scattered_calling_intervals/${file}/${file}.interval_list
done