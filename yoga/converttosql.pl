#!/opt/local/bin/perl

open SQL, "> loaddb.sql";
select SQL;

### Users
$namecount=100;
open NAMES, "names.txt" || die "Cannot open names.txt";
while(<NAMES>) {
    chomp;
    print "INSERT INTO User(id,name) VALUES ($namecount, '$_')\n";
    ++$namecount;
}
close NAMES;

### Friends
for($i = 100 ; $i < $namecount; ++$i) {
    # Temporarily put self in here, to avoid collisions
    %friends = ($i, 1);
    $friendid = $i;

    # Give everyone 50 friends
    for($j = 0; $j < 50; ++$j) {
	while($friends{$friendid}) {
	    $friendid = int(rand($namecount - 100)) + 100;
	}
	$friends{$friendid} = 1;
    }
    delete($friends{$i});

    foreach $key (keys %friends) {
	print "INSERT INTO Friend(userid, friendid) VALUES ($i, $key)\n";
    }
}

### Songs
$bandcount=100;
$albumcount=100;
$songcount=100;

open SONGS, "songs.csv" || die "Cannot open songs.csv";
while(<SONGS>) {
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
close SONGS;

### Faves
for($i = 100 ; $i < $namecount; ++$i) {
    %faves = (-1, 1);
    $faveid = -1;

    # Give everyone 5 faves
    for($j = 0; $j < 5; ++$j) {
        while($faves{$faveid}) {
            $faveid = int(rand($bandcount - 100)) + 101;
        }
        $faves{$faveid} = 1;
    }
    delete($faves{-1});

    foreach $key (keys %faves) {
	print "INSERT INTO Fan(userId, artistId)  VALUES($i, $key)\n";
    }
}

close SQL;
