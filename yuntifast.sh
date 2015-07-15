#!/bin/bash

###############################################
#
# A utility to decide which Yunti node to use
#
##############################################

SERVERS=(
jp1.vpnhide.com
jp2.vpnhide.com
jp3.vpnhide.com
us1.vpnhide.com
us2.vpnhide.com
us3.vpnhide.com
us4.vpnhide.com
us5.vpnhide.com
sg1.vpnhide.com
sg2.vpnhide.com
hk1.vpnhide.com
hk2.vpnhide.com
tw1.vpnhide.com
uk1.vpnhide.com
)

function get_loss() {
    output=`ping -c $PING_COUNT $1`
    loss=`echo $output | tail -2 | head -1 | awk -F, '{print $3}' | awk -F\  '{print $1}'`
    echo "$loss | $1"

    if [ -z "$output" ]
    then
        >&2 echo $output 
    fi
}

function gen_commands {
    for server in ${SERVERS[@]}; do
        echo get_loss $server
    done
}

export PING_COUNT=20
export -f get_loss

commands=`gen_commands`


output=`parallel --jobs ${#SERVERS[@]} --will-cite <<EOF
$commands
EOF`

sort -g <<EOF
$output
EOF
