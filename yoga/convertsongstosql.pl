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

    unless ($bandid{$band}) {
	$bandid{$band} = ++$bandcount;
	$band =~ s/'/''/g;
	print "INSERT INTO Artist(id, name)  VALUES($bandcount, '$band')\n";
    }
    unless ($albumid{$bandid{$band} . "_" . $album}) {
	$albumid{$bandid{$band} . "_" . $album} = ++$albumcount;
	$album =~ s/'/''/g;
	print "INSERT INTO Album(id, title, artistId, year)  VALUES($albumcount, '$album', $bandid{$band}, 1974)\n";
    }
    ++$songcount;
    $song =~ s/'/''/g;
    print "INSERT INTO Song(id, title, artistId, albumId)  VALUES($songcount, '$song', $bandid{$band}, "
	. $albumid{$bandid{$band} . "_" . $album} . ")\n";

}
