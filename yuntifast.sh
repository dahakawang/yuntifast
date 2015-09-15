#!/bin/bash

###############################################
#
# A utility to decide which Yunti node to use
#
##############################################

SERVERS=(
p1.jp1.vpnhide.com
p2.jp1.vpnhide.com
p1.jp2.vpnhide.com
p2.jp2.vpnhide.com
p1.jp3.vpnhide.com
p2.jp3.vpnhide.com
p1.us1.vpnhide.com
p2.us1.vpnhide.com
p2.us2.vpnhide.com
p1.us2.vpnhide.com
p1.us3.vpnhide.com
p2.us3.vpnhide.com
p1.us4.vpnhide.com
p2.us4.vpnhide.com
p1.us5.vpnhide.com
p2.us5.vpnhide.com
p1.sg1.vpnhide.com
p2.sg1.vpnhide.com
p1.sg2.vpnhide.com
p2.sg2.vpnhide.com
p1.hk1.vpnhide.com
p2.hk1.vpnhide.com
p1.hk2.vpnhide.com
p2.hk2.vpnhide.com
p1.tw1.vpnhide.com
p2.tw1.vpnhide.com
p1.uk1.vpnhide.com
p2.uk1.vpnhide.com
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
