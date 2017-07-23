a=0
for i in TRUE FALSE TRUE
do
    echo $i
    ((a++))
done
echo $a

violin='FALSE'
violin_jitter='FALSE'
jitter='d'
boxplot_jitter='t'

b=0
fo=($violin $violin_jitter $jitter $boxplot_jitter)  ##如果字符串有空格，则用引号

for i in ${fo[@]}
do
    if [ $i != 'FALSE' ];then
        echo $i
        ((b++))
    fi     
done

if [ $b -gt 1 ];then
    echo "You can only choose one of these (-V -W -j -J)"
    exit 1
fi
