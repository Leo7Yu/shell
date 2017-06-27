#! /bin/sh -

result_path='/home/ec2-user/result'

less /var/log/shadowsocks.log | \
grep 'INFO' | \
grep 'connecting' | \
awk -F ' from ' '{print $2}' | \
awk -F ':' '{print $1}' | \
sort | uniq -c | sort -rn -k1 \
> $result_path/connect_ip_number

cat /dev/null > $result_path/analyse-ip-result

isSafe=1
while read line; do
  ip=${line/[0-9]* /}

  temp=$(curl -s 'http://ip138.com/ips138.asp?ip='$ip'&action=2' | iconv -f gb2312 -t utf-8 | grep '本站数据' | grep -v '北京')
  if [[ -z ${temp} ]]; then
     echo $line' is safe' >> $result_path/analyse-ip-result
  else
     isSage=0
     echo "suspicious ip: "$line+$temp
     echo $line+$temp >> $result_path/analyse-ip-result
  fi

done < $result_path/connect_ip_number

echo "it's safe when above is empty"
echo 'analyse ip result path is: '$result_path'/analyse-ip-result'
rm -f $result_path/connect_ip_number

if [[ $isSafe -eq 0 ]]; then 
  mail -s "aws1 analyse ip result" yujianfeng@jf180.cn < $result_path/analyse-ip-result
fi
#iptables -I INPUT -s 106.120.244.253 -j DROP
#/etc/rc.d/init.d/iptables save
#cat /etc/sysconfig/iptables
