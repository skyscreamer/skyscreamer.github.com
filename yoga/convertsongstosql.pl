#!/opt/local/bin/perl

$bandcount=100;
$albumcount=100;
$songcount=100;

while(<>) {
    chomp;
    @a = split(/,/);
    $band = @a[0];
    $album = $a[1];
    $song = $a[2];

    $bandkey = $band;
    $bandkey =~ s/'//g;
    unless ($bandid{$bandkey}) {
	$bandid{$bandkey} = ++$bandcount;
	$band =~ s/'/''/g;
	print "INSERT INTO Artist(id, name)  VALUES($bandcount, '$band')\n";
    }
    $albumkey = $bandid{$bandkey} . "_" . $album;
    $albumkey =~ s/'//g;
    unless ($albumid{$albumkey}) {
	$albumid{$albumkey} = ++$albumcount;
	$album =~ s/'/''/g;
	print "INSERT INTO Album(id, title, artistId, year)  VALUES($albumcount, '$album', $bandid{$bandkey}, 1974)\n";
    }
    ++$songcount;
    $song =~ s/'/''/g;
    print "INSERT INTO Song(id, title, artistId, albumId)  VALUES($songcount, '$song', $bandid{$bandkey}, "
	. $albumid{$albumkey} . ")\n";

}
