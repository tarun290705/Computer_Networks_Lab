BEGIN {No_of_pkts=0;}
{
    if($1=="r" && $3=="_1_" && $4=="AGT" && $7=="tcp")
    {
        No_of_pkts = No_of_pkts + $8;
    }
}
END {
    Throughput = No_of_pkts * 8 / $2 / 1000000;
    printf("\n\n\t Throughput = %f bpms\n\n", Throughput);
}


# Running AWK File:

# ns prog10.tcl
# awk -f prog10.awk out.tr