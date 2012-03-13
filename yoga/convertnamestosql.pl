#!/opt/local/bin/perl

$count=100;
while(<>) {
    chomp;
    print "INSERT INTO User(id,name) VALUES ($count, '$_')\n";
    ++$count;
}

