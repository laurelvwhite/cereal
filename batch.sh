for cluster in $(awk '{print $1}' lowm.txt);
do
    mkdir clusters/$cluster.html
done
