#!/bin/bash
cd "$(dirname "${0}")/../" || exit
plain=$(dd if=/dev/random ibs=16 count=1 2>/dev/null|xxd -p)
echo "1:${plain:0:8}-${plain:8:4}-${plain:12:4}-${plain:16:4}-${plain:20:12}"
plain=$(md5 -qs "${plain}")
echo "2:${plain:0:4}-${plain:8:2}-${plain:12:2}-${plain:16:2}-${plain:20:6}"
plain=$(md5 -qs "${plain}")
echo "3:${plain:0:2}-${plain:8:1}-${plain:12:1}-${plain:16:1}-${plain:20:3}"