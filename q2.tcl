set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set nd [open Q2_drop.tr w]
$ns trace-all $nd

$ns color 0 Orange
$ns color 1 Red
$ns color 2 Green
$ns color 3 Yellow

proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam
    exit 0
}

for {set i 0} {$i < 6} {incr i} {
	set node($i) [$ns node]
}

set Q1_size 2
set Q2_size 4
set Q3_size 2
set Q4_size 4
set Q5_size 2

$ns duplex-link $node(0) $node(2) 1Mb 10ms DropTail
$ns queue-limit $node(0) $node(2) $Q1_size
$ns duplex-link $node(1) $node(2) 512kb 10ms DropTail
$ns queue-limit $node(1) $node(2) $Q2_size
$ns duplex-link $node(2) $node(3) 1Mb 10ms DropTail
$ns queue-limit $node(2) $node(3) $Q3_size
$ns duplex-link $node(3) $node(4) 512kb 10ms DropTail
$ns queue-limit $node(3) $node(4) $Q4_size
$ns duplex-link $node(3) $node(5) 512kb 10ms DropTail
$ns queue-limit $node(3) $node(5) $Q5_size
Agent/Ping instproc recv {from rtt} {
	$self instvar node_
	puts "node [$node_ id] received ping answer from \
              $from with round-trip-time $rtt ms."
}
set p0 [new Agent/Ping]
$ns attach-agent $node(0) $p0
set p1 [new Agent/Ping]
$ns attach-agent $node(4) $p1
set p2 [new Agent/Ping]
$ns attach-agent $node(1) $p2
set p3 [new Agent/Ping]
$ns attach-agent $node(5) $p3
$ns connect $p0 $p1
$ns connect $p2 $p3
for {set i 1} {$i < 100} {incr i} {
	$ns at [expr ($i)* 0.01] "$p1 send"
}
for {set i 1} {$i < 100} {incr i} {
	$ns at [expr ($i)* 0.01] "$p3 send"
}
$ns at 1.0 "finish"
$ns run