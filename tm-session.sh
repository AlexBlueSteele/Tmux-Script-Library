#!/bin/bash
if [ $# -lt 1 ]
then
  # when no arguments, just run tmux ls to see what sessions are active
  # and select one of them
  select session in `tmux ls | sed -e 's/\(^.*\): .*/\1/'` quit
  do
	 if [ $session == "quit" ]
	 then
		exit 0
	 fi
    break
  done
else
  session=$1
fi
 
sessionExists=`tmux ls 2> /dev/null | grep $session | wc -l`

if [ $sessionExists == "1" ]
then
  echo Session $session already exists
else
  echo Creating new tmux session $session
  case $2 in
  "") tmux new-session -d -s $session ;;
	1) tmux new-session -d -s $session ;;
	2) tmux new-session -d -s $session \; split-window -v ;;
	3) tmux new-session -d -s $session \; split-window -v \; \
			                                split-window -h ;;
	4) tmux new-session -d -s $session \; split-window -v \; \
			                                split-window -h \; \
				                             select-pane  -U \; \
													  split-window -h ;;
	*) echo The window configuration may be no larger than 4
  		exit 1 ;;
  esac
fi
 
read -p "  Attach or kill session: $session or quit [A/k/q]? " ans
if [[ -z $ans || $ans == "A" ]]
then
  tmux attach-session -t $session
elif [ $ans == "k" ]
then
  tmux kill-session -t $session
fi

