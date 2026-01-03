# 9. To Simulate and study of Go Back N Protocol

set ns [ new Simulator ]

set tr [ open out.tr w ]
$ns trace-all $tr 

set nam [ open out.nam w ]
$ns namtrace-all $nam

set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]
set n3 [ $ns node ]

$ns duplex-link $n0 $n1 1Mb 20ms DropTail
$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link $n1 $n2 1Mb 20ms DropTail
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link $n2 $n3 1Mb 20ms DropTail
$ns duplex-link-op $n2 $n3 orient right-up

set tcp [ new Agent/TCP ]
$tcp set fid_ 1
set sink [ new Agent/TCPSink ]

$ns attach-agent $n0 $tcp
$ns attach-agent $n3 $sink 

$ns connect $tcp $sink

set ftp [ new Application/FTP ]
$ftp attach-agent $tcp

$ns at 0.05 "$ftp start"
$ns at 0.06 "$tcp set window_ 6"
$ns at 0.06 "$tcp set maxcwnd_ 6"
$ns at 0.25 "$ns queue-limit $n2 $n3 0"
$ns at 0.26 "$ns queue-limit $n2 $n3 10"
$ns at 0.305 "$tcp set window_ 4"
$ns at 0.305 "$tcp set maxcwnd_ 4"
$ns at 0.368 "$ns detach-agent $n0 $tcp; $ns detach-agent $n3 $sink"
$ns at 1.5 "finish"

$ns at 0.0 "$ns trace-annotate \"Goback N end\""
$ns at 0.05 "$ns trace-annotate \"FTP starts at 0.05\""
$ns at 0.06 "$ns trace-annotate \"Send 6 packets from SYS1 to SYS4\""
$ns at 0.26 "$ns trace-annotate \"Error occurs for 3rd packet, so ack is not sent for the packet\""
$ns at 0.30 "$ns trace-annotate \"Retransmit Packet_3 to 6\""
$ns at 1.0 "$ns trace-annotate \"FTP stops\""

proc finish {} {
    global ns tr nam
    $ns flush-trace
    close $tr
    close $nam
    puts "Filtering..."
    exec nam out.nam &
    exit 0
}
$ns run