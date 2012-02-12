#!/bin/sh
for i in $(cat sophia.conf |grep grid5000 |cut -d ' ' -f 1);
do
  port=`cat sophia.conf |grep $i |cut -d ' ' -f 2`
  switch=`cat sophia.conf |grep $i |cut -d ' ' -f 3`
  echo "$i:\n      switch_port: $port\n      switch: $switch";
done
