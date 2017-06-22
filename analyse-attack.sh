#! /bin/sh -

result_path='/home/ec2-user/result'

less /var/log/shadowsocks.log | \
grep -i 'error' | \
grep 'can not parse header' | \
awk -F 'can not parse header when handling connection from' '{print $2}' | \
awk -F ':' '{print $1}' | \
sort | uniq -c | sort -rn -k1 \
> $result_path/pw_error_ip_number

echo 'the error of can not parse header when handling connection:'
head -3 $result_path/pw_error_ip_number

#iptables -I INPUT -s 106.120.244.253 -j DROP
#/etc/rc.d/init.d/iptables save
#cat /etc/sysconfig/iptables
