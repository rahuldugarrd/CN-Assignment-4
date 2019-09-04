set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set nd [open out.tr w]
$ns trace-all $nd

proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam
    exit 0
}
for {set i 0} {$i < 3} {incr i} {
    set node($i) [$ns node]
}

set size1 5
set size2 10
$ns duplex-link $node(0) $node(1) 1Mb 10ms DropTail
$ns queue-limit $node(0) $node(1) $size1
$ns duplex-link $node(0) $node(2) 1Mb 10ms DropTail
$ns queue-limit $node(0) $node(2) $size2

$ns color 2 Red

set tcp_con [new Agent/TCP]
$ns attach-agent $node(1) $tcp_con
$tcp_con set class_ 2

set sink_node [new Agent/TCPSink]
$ns attach-agent $node(2) $sink_node
$ns connect $tcp_con $sink_node

$tcp_con set fid_ 2

set ftp_con [new Application/FTP]
$ftp_con attach-agent $tcp_con

$ns at 0.1 "$ftp_con start"
$ns at 1.5 "$ftp_con stop"
$ns at 2.0 "finish"


$ns run