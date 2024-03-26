#!/bin/bash

nohup tail -f /var/log/messages | grep -f ./configs/journal_patterns.txt | tee ./logs/host_journal.log &
