#!/usr/bin/env python3

import sys
import os

def check_smtp(liste: str):
    if not os.path.exists("smtp"):
        os.mkdir("smtp")
    os.system("bash ses_checker.sh "+liste)

def check_aws(liste: str):
    if not os.path.exists("panel"):
        os.mkdir("panel")
    os.system("bash aws_checker.sh "+liste)

def check_sns(liste: str):
    if not os.path.exists("sns"):
        os.mkdir("sns")
    os.system("bash sns_checker.sh "+liste)

try:
    liste = str(sys.argv[1])
    print("\n1) SMTP AWS  \n")
    print("2) PANEL AWS \n")
    print("3) SNS AWS \n")
    
    selection = int(input("Please select: "))
    
    if selection not in [1, 2, 3]:
        print("Invalid selection")
        exit(84)
    
    switch = {
        2: check_aws,
        1: check_smtp,
        3: check_sns
    }
    switch.get(selection)(liste)

except (IndexError, ValueError) as e:
    print("No file specified or invalid selection")
    exit(84)

exit(0)
