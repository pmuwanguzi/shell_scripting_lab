#!/usr/bin/env bash

#Defining main_dir
main_dir="submission_reminder_app"
#Define sub_dirs
sub_dirs=("app" "modules" "assets" "config")

#Creating directory called submission_reminder_app
if [ ! -d "$main_dir" ]
then
	mkdir "$main_dir"
	echo "submission_remider_app Directory created."
	#create setup file in new main directory.
	touch "$main_dir/startup.sh"
	startup="$main_dir/startup.sh"
	echo "#!/usr/bin/bash" > "$startup"
	echo "./app/reminder.sh" > "$startup"
	chmod +x "$startup"
        #Loop through the sub_dirs to created them
	for sub_dir in "${sub_dirs[@]}" 
	do
		sub_dir_path="$main_dir/$sub_dir"
		if [ ! -d "$sub_dir_path" ]
		then 
			mkdir "$sub_dir_path"
			echo "Subdirectory '$sub_dir_path' created."
		fi
	done

	#Create reminder.sh
	touch "$main_dir/app/reminder.sh"
	#convert path into variable
	reminder="$main_dir/app/reminder.sh"
	# Write the content to the reminder.sh file
	echo "#!/bin/bash" > "$reminder"
	echo "" >> "$reminder"
	echo "# Source environment variables and helper functions" >> "$reminder"
	echo "source ./config/config.env" >> "$reminder"
	echo "source ./modules/functions.sh" >> "$reminder"
	echo "" >> "$reminder"
	echo "# Path to the submissions file" >> "$reminder"
	echo 'submissions_file="./assets/submissions.txt"' >>"$reminder"
	echo "" >> "$reminder"
	echo "# Print remaining time and run the reminder function" >> "$reminder"
	echo 'echo "Assignment: $ASSIGNMENT"' >> "$reminder"
	echo 'echo "Days remaining to submit: $DAYS_REMAINING days"' >> "$reminder"
	echo 'echo "--------------------------------------------"' >> "$reminder"
	echo "" >> "$reminder"
	echo "check_submissions $submissions_file" >> "$reminder"

	# Make reminder.sh executable
	chmod +x "$reminder"

	# Communicate to the user what has happened
	echo "The Script '$reminder' has been created and made executable."
	
	#Create the functions.sh file
	touch "$main_dir/modules/functions.sh"
	#Convert Functions file path to variable functions
	functions="$main_dir/modules/functions.sh"

	#Write content to functions
	# Write content to the file
	echo "#!/bin/bash" > "$functions"
	echo "" >> "$functions"
	echo "# Function to read submissions file and output students who have not submitted" >> "$functions"
	echo "function check_submissions {" >> "$functions"
	echo "    local submissions_file=\$1" >> "$functions"
	echo '    echo "Checking submissions in \$submissions_file"' >> "$functions"
	echo "" >> "$functions"
	echo "    # Skip the header and iterate through the lines" >> "$functions"
	echo "    while IFS=, read -r student assignment status; do" >> "$functions"
	echo "        # Remove leading and trailing whitespace" >> "$functions"
	echo '        student=$(echo "$student" | xargs)' >> "$functions"
	echo '        assignment=$(echo "$assignment" | xargs)' >> "$functions"
	echo '        status=$(echo "$status" | xargs)' >> "$functions"
	echo "" >> "$functions"
	echo "        # Check if assignment matches and status is 'not submitted'" >> "$functions"
	echo '        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then' >> "$functions"
	echo '            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"' >> "$functions"
	echo "        fi" >> "$functions"
	echo "    done < <(tail -n +2 \"$submissions_file\") # Skip the header" >> "$functions"
	echo "}" >> "$functions"
	
	chmod +x "$functions"
	# Notify the user
	echo "Content has been written to the file '$functions'."
	


	cp submissions.txt "$main_dir/assets/submissions.txt"
	
	touch "$main_dir/config/config.env"
	config="$main_dir/config/config.env"
	# Write content to the config.env
	echo "# This is the config file" > "$config"
	echo 'export ASSIGNMENT="Shell Navigation"' >> "$config"
	echo "export DAYS_REMAINING=2" >> "$config"
else 
	echo "Directory called submission_reminder_app already exist."
fi
