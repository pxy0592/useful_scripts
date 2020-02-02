#!/bin/env bash

cmd=$(which tmux)      # tmux path        
                                                              
if [ -z $cmd ]; then              
    echo "You need to install tmux."      
    exit 1                               
fi                      
                                    
session="xpan"
$cmd has -t $session 2> /dev/null       
                                                             
if [ $? != 0 ]; then                                                     
    $cmd new -d -n base-act -s $session "bash"    
    $cmd splitw -v -t $session                    
    $cmd splitw -h -t $session                   
    $cmd select-layout -t $session tiled        
#    $cmd send-keys -t $session:1.0 '执行的命令' C-m     
#    $cmd send-keys -t $session:1.1 '执行的命令' C-m      
#    $cmd send-keys -t $session:1.2 '执行的命令' C-m      
#    $cmd send-keys -t $session:1.3 '执行的命令' C-m 
    $cmd set-window-option synchronize-panes on        
#    $cmd neww -n vim -t $session "bash"         
#    $cmd selectw -t $session:5        
fi                          
                                              
$cmd att -t $session                 
                  
exit 0  
