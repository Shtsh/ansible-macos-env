ALERT_IF_IN_NEXT_MINUTES=60
ALERT_POPUP_BEFORE_SECONDS=60
NERD_FONT_FREE="󱁕"
NERD_FONT_MEETING=""

get_attendees() {
	attendees=$(
	icalBuddy \
		--includeEventProps "attendees" \
		--propertyOrder "datetime,title" \
		--noCalendarNames \
		--dateFormat "%A" \
		--includeOnlyEventsFromNowOn \
		--limitItems 1 \
		--excludeAllDayEvents \
		--separateByDate \
		--excludeEndDates \
		--bullet "" \
		--excludeCals "training,omerxx@gmail.com" \
		eventsToday)
}

parse_attendees() {
	attendees_array=()
	for line in $attendees; do
		attendees_array+=("$line")
	done
	number_of_attendees=$((${#attendees_array[@]}-3))
}

get_next_meeting() {
	next_meeting=$(icalBuddy \
		--includeEventProps "title,datetime" \
		--propertyOrder "datetime,title" \
		--noCalendarNames \
		--dateFormat "%A" \
		--includeOnlyEventsFromNowOn \
		--limitItems 1 \
		--excludeAllDayEvents \
		--separateByDate \
		--bullet "" \
		--excludeCals "training,omerxx@gmail.com" \
		eventsToday)
}

get_next_next_meeting() {
	end_timestamp=$(date +"%Y-%m-%d ${end_time}:01 %z")
	tonight=$(date +"%Y-%m-%d 23:59:00 %z")
	next_next_meeting=$(
	icalBuddy \
		--includeEventProps "title,datetime" \
		--propertyOrder "datetime,title" \
		--noCalendarNames \
		--dateFormat "%A" \
		--limitItems 1 \
		--excludeAllDayEvents \
		--separateByDate \
		--bullet "" \
		--excludeCals "training,omerxx@gmail.com" \
		eventsFrom:"${end_timestamp}" to:"${tonight}")
}

parse_result() {
	array=()
	for line in $1; do
		array+=("$line")
	done
	time="${array[2]}"
	end_time="${array[4]}"
	title="${array[*]:5:30}"
}

calculate_times(){
	epoc_meeting=$(date -j -f "%T" "$time:00" +%s)
	epoc_now=$(date +%s)
	epoc_diff=$((epoc_meeting - epoc_now))
	minutes_till_meeting=$((epoc_diff/60))

	epoc_meeting_end=$(date -j -f "%T" "$end_time:00" +%s)
	epoc_end_diff=$((epoc_meeting_end - epoc_now))
	minutes_till_meeting_end=$((epoc_end_diff/60))
}

display_popup() {
	tmux display-popup \
		-S "fg=#eba0ac" \
		-w50% \
		-h50% \
		-d '#{pane_current_path}' \
		-T meeting \
		icalBuddy \
			--propertyOrder "datetime,title" \
			--noCalendarNames \
			--formatOutput \
			--includeEventProps "title,datetime,notes,url,attendees" \
			--includeOnlyEventsFromNowOn \
			--limitItems 1 \
			--excludeAllDayEvents \
			--excludeCals "training" \
			eventsToday
}

print_tmux_status() {
	if [[ $next_meeting != "" && $minutes_till_meeting -lt $ALERT_IF_IN_NEXT_MINUTES ]]; then
		if [[ $minutes_till_meeting -gt 0 ]]; then
			echo "${minutes_till_meeting}m: ${title::50}"
		else
			echo "${minutes_till_meeting_end}m left: ${title::50}"
		fi
	else
		echo "$NERD_FONT_FREE"
	fi

	if [[ $epoc_diff -gt $ALERT_POPUP_BEFORE_SECONDS && epoc_diff -lt $ALERT_POPUP_BEFORE_SECONDS+10 ]]; then
		display_popup
	fi
}

main() {
	get_attendees
	parse_attendees
	get_next_meeting
	parse_result "$next_meeting"
	calculate_times
	if [[ "$next_meeting" != "" && $minutes_till_meeting_end -lt 10 ]]; then
		get_next_next_meeting
		if [[ "$next_next_meeting" != "" ]]; then
			parse_result "$next_next_meeting"
			calculate_times
		fi
	fi
	print_tmux_status
}

main
