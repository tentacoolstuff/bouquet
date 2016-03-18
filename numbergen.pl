&main();

sub main {	
	use DBI;
	use Class::Struct;
	use Math::Trig;
	struct( Report => [ m1 => '$',m2 => '$',m3 => '$',hum => '$',t1 => '$',batteryLv => '$',
		Reporttime => '$', dand => '$', state => '$']);

	struct( vReport => [ valve => '@', vReporttime => '$', vstate => '$']);

	if ( !$ARGV[0] ) {
		die "\tNumber of reports per Dandelion must be specified.\n\n";
	}
	my $reps = $ARGV[0];
	my @Reports;
	my @vReports;
	
	# connect
	my $dbh = DBI->connect("DBI:Pg:dbname=postgres;host=localhost", "postgres", "autom8", {'RaiseError' => 1});
	my $d = 1; #starting date
	my $h = 16; #starting hour
	my $m = 0; #startomg min 
	
	#clear previous reports 
	$dbh->do('DELETE from reports');
	$dbh->do('DELETE from valve_reports');
	
	# create initial values (15 reports )
	#my $time = localtime;
	my $time = '2016-03-'.$d .' '. $h .':'. $m .':00-05';
	my $rm = rand(0.6) +0.4;

	$Reports[0] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'e4590694-8275-4494-b486-f8cebfb85dad', state => '1' );
	$rm = rand(0.6) +0.4;
	$Reports[1] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'b7ea29b3-c229-4f57-960d-ad1f673a5ee2', state => '1' );
	$rm = rand(0.6) +0.4;
	$Reports[2] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => '983d3578-3178-42fb-964f-fd57af189242', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[3] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'f922478c-416c-43f2-ab00-68af13e18c5a', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[4] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'a58fdf58-697c-40c2-9666-8dc127a8679f', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[5] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'f927470a-496c-43f9-cb10-18af13e18c5a', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[6] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'f927470a-497c-43f9-cb10-18af13e18c5a', state => '1' );
		$rm = rand(0.6) +0.4;



	$Reports[7] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'a927470a-497c-43f9-cb10-28af13e18c5a', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[8] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'b927470a-497d-43f9-cb10-18af13e18c5a', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[9] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'c927470a-497d-53f9-cb10-18af13e18c5a', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[10] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'd937470a-497d-53f9-cb10-18af13e18c5a', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[11] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'e937470a-497d-54f9-cb10-18af13e18c5a', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[12] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'f937471a-497d-54f9-cb10-18af13e18c5a', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[13] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'a937472a-497d-54f9-cb10-18af13e18c5a', state => '1' );
		$rm = rand(0.6) +0.4;
	$Reports[14] = Report ->new( m1 => $rm, m2 => $rm, m3 => $rm,hum => 0.75,t1 => 303,batteryLv => 99,
		Reporttime => $time, dand => 'b937571a-497d-54f9-cb10-18af13e18c5b', state => '1' );
		$rm = rand(0.6) +0.4;
	
	my $j=14;
	my $rm2;
	my $rm3;
	my $hum;
	my $t1;
	my $watersneeded = 0;
	$nvReport = new vReport;
	
	for (my $i=1; $i < $reps; $i++) {
   		#shift time up by 10 minutes for next round of reports
		($d, $h, $m) = nextTime($d, $h, $m);
		($hum, $t1) = dailyCurve($h, $m);
		my $time = '2016-03-'.$d .' '. $h .':'. $m .':00-05';
		
		$j = $j + 1;
   		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 1);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'e4590694-8275-4494-b486-f8cebfb85dad', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['2','n','d','c'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}
		
		$j = $j + 1;
   		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 1);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'b7ea29b3-c229-4f57-960d-ad1f673a5ee2', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['f','i','r','s','t','c'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}
		
		$j = $j + 1;
   		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 1);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => '983d3578-3178-42fb-964f-fd57af189242', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['f','i','r','s','t','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}
		
		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 1);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'f922478c-416c-43f2-ab00-68af13e18c5a', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['f','i','r','s','t','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}
		
		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 1);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'a58fdf58-697c-40c2-9666-8dc127a8679f', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}

		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 1);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'f927470a-496c-43f9-cb10-18af13e18c5a', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}

		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 1);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'f927470a-497c-43f9-cb10-18af13e18c5a', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}



		#new
		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 2);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'a927470a-497c-43f9-cb10-28af13e18c5a', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}

		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 2);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'b927470a-497d-43f9-cb10-18af13e18c5a', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}

		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 2);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'c927470a-497d-53f9-cb10-18af13e18c5a', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}

		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 2);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'd937470a-497d-53f9-cb10-18af13e18c5a', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}

		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 2);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'e937470a-497d-54f9-cb10-18af13e18c5a', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}

		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 2);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'f937471a-497d-54f9-cb10-18af13e18c5a', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}

		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 2);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'a937472a-497d-54f9-cb10-18af13e18c5a', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}

		$j = $j + 1;
		($rm, $rm2, $rm3, $watersneeded) = dry($Reports[$j-15]->m1, 2);
   		$Reports[$j] = Report->new( m1 => $rm, m2 => $rm2, m3 => $rm3,hum => $hum,t1 => $t1,batteryLv => 99,
			Reporttime => $time, dand => 'b937571a-497d-54f9-cb10-18af13e18c5b', state => '1' );
		if ($watersneeded == 1){
			$nvReport = vReport->new ( valve => ['s','e','c','o','n','d','p'], vReporttime => $time, vstate => 2);
			push @vReports, $nvReport;
			$watersneeded = 0;
		}
		
	}
	
	my $sth;
	for (my $k=0; $k <= $j; $k++) {
		$sth = $dbh->prepare("INSERT INTO Reports(moisture1, moisture2, moisture3, humidity, temperature1, temperature2, temperature3, batterylevel,
			reporttime,dandelionid,stateid) VALUES(?,?,?,?,?,?,?,?,?,?,?)");
		$sth->execute($Reports[$k]->m1, $Reports[$k]->m2, $Reports[$k]->m3, $Reports[$k]->hum, $Reports[$k]->t1, $Reports[$k]->t1, $Reports[$k]->t1, $Reports[$k]->batteryLv,
			$Reports[$k]->Reporttime, $Reports[$k]->dand, $Reports[$k]->state);
	}
	
	foreach $ivReport (@vReports){
    	$sth = $dbh->prepare("INSERT INTO valve_Reports(valveid, reporttime, valvestatusid) VALUES(?,?,?)");
		$sth->execute($ivReport->valve, $ivReport->vReporttime, $ivReport->vstate);
	}
	
	# clean up
	$dbh->disconnect();
	print "Done.";
}

sub dry {
	my ($mm , $soil) = @_;
	$mm = $mm - .2;
	my $waterneeded = 0;
	if ($soil == 1)
	{
		if ($mm > 0.736035532)
		{
			$mm = 0.67718538 + rand(0.736035532 - 0.67718538);
		}
		elsif ($mm > 0.67718538)
		{
			$mm = 0.623040626 + rand(0.67718538 - 0.623040626);
		}
		elsif ($mm > 0.623040626)
		{
			$mm = 0.573225048 + rand(0.623040626 - 0.573225048);
		}
		elsif ($mm > 0.573225048)
		{
			$mm = 0.527392504 + rand(0.573225048 - 0.527392504);
		}
		elsif ($mm > 0.527392504)
		{
			$mm = 0.485224528 + rand(0.527392504 - 0.485224528);
		}
		elsif ($mm > 0.485224528)
		{
			$mm = 0.446428117 + rand(0.485224528 - 0.446428117);
		}
		elsif ($mm > 0.446428117)
		{
			$mm = 0.410733695 + rand(0.446428117 - 0.410733695);
		}
		elsif ($mm > 0.410733695)
		{
			$mm = 0.377893242 + rand(0.410733695 - 0.377893242);
		}
		elsif ($mm > 0.377893242)
		{
			$mm = 0.347678567 + rand(0.377893242 - 0.347678567);
		}
		elsif ($mm > 0.347678567)
		{
			$mm = 0.319879723 + rand(0.347678567 - 0.319879723);
		}
		elsif ($mm > 0.319879723)
		{
			$mm = 0.294303553 + rand(0.319879723 - 0.294303553);
		}
		elsif ($mm > 0.294303553)
		{
			$mm = 0.27077234 + rand(0.294303553 - 0.27077234);
		}
		elsif ($mm > 0.27077234)
		{
			$mm = 0.249122579 + rand(0.27077234 - 0.249122579);
		}
		elsif ($mm > 0.249122579)
		{
			$mm = 0.229203837 + rand(0.249122579 - 0.229203837);
		}
		elsif ($mm > 0.229203837)
		{
			$mm = 0.21087771 + rand(0.229203837 - 0.21087771);
		}
		elsif ($mm > 0.21087771)
		{
			$mm = 0.19401686 + rand(0.21087771 - 0.19401686);
		}
		elsif ($mm < 0.21087771)
		{
			$waterneeded = 1;
			$mm = 0.736035532 + rand(1 - 0.736035532);
		}
	}
	else {
		if ($mm > 0.757188118)
		{
			$mm = 0.716667308 + rand(0.757188118 - 0.716667308);
		}
		elsif ($mm > 0.716667308)
		{
			$mm = 0.678314963 + rand(0.716667308 - 0.678314963);
		}
		elsif ($mm > 0.678314963)
		{
			$mm = 0.642015038 + rand(0.678314963 - 0.642015038);
		}
		elsif ($mm > 0.642015038)
		{
			$mm = 0.607657699 + rand(0.642015038 - 0.607657699);
		}
		elsif ($mm > 0.607657699)
		{
			$mm = 0.575138987 + rand(0.607657699 - 0.575138987);
		}
		elsif ($mm > 0.575138987)
		{
			$mm = 0.544360509 + rand(0.575138987 - 0.544360509);
		}
		elsif ($mm > 0.544360509)
		{
			$mm = 0.515229137 + rand(0.544360509 - 0.515229137);
		}
		elsif ($mm > 0.515229137)
		{
			$mm = 0.487656726 + rand(0.515229137 - 0.487656726);
		}
		elsif ($mm > 0.487656726)
		{
			$mm = 0.461559848 + rand(0.487656726 - 0.461559848);
		}
		elsif ($mm > 0.461559848)
		{
			$mm = 0.436859541 + rand(0.461559848 - 0.436859541);
		}
		elsif ($mm > 0.436859541)
		{
			$mm = 0.413481068 + rand(0.436859541 - 0.413481068);
		}
		elsif ($mm > 0.413481068)
		{
			$mm = 0.391353689 + rand(0.413481068 - 0.391353689);
		}
		elsif ($mm > 0.391353689)
		{
			$mm = 0.370410455 + rand(0.391353689 - 0.370410455);
		}
		elsif ($mm > 0.370410455)
		{
			$mm = 0.350587994 + rand(0.370410455 - 0.350587994);
		}
		elsif ($mm > 0.350587994)
		{
			$mm = 0.331826329 + rand(0.350587994 - 0.331826329);
		}
		elsif ($mm > 0.331826329)
		{
			$mm = 0.314068692 + rand(0.331826329 - 0.314068692);
		}
		elsif ($mm > 0.314068692)
		{
			$mm = 0.297261353 + rand(0.314068692 - 0.297261353);
		}
		elsif ($mm > 0.297261353)
		{
			$mm = 0.281353456 + rand(0.297261353 - 0.281353456);
		}
		elsif ($mm > 0.281353456)
		{
			$mm = 0.266296867 + rand(0.281353456 - 0.266296867);
		}
		elsif ($mm > 0.266296867)
		{
			$mm = 0.25204603 + rand(0.266296867 - 0.25204603);
		}
		elsif ($mm > 0.25204603)
		{
			$mm = 0.238557824 + rand(0.25204603 - 0.238557824);
		}
		elsif ($mm > 0.238557824)
		{
			$mm = 0.225791437 + rand(0.238557824 - 0.225791437);
		}
		elsif ($mm > 0.225791437)
		{
			$mm = 0.213708242 + rand(0.225791437 - 0.213708242);
		}
		elsif ($mm > 0.213708242)
		{
			$mm = 0.202271677 + rand(0.213708242 - 0.202271677);
		}
		elsif ($mm > 0.202271677)
		{
			$mm = 0.191447138 + rand(0.202271677 - 0.191447138);
		}
		elsif ($mm < 0.202271677)
		{
			$waterneeded = 1;
			$mm = 0.757188118 + rand(1 - 0.757188118);
		}
	} 
	$mm = $mm + 0.2;
	my $mm1 = $mm*(1 - rand(0.10));
	my $mm2 = $mm*(1 - rand(0.03));
	
	return ($mm1 ,$mm2, $mm, $waterneeded);
}

sub nextTime {
	my ($od, $oh, $om)= @_;
	$om = $om + 10;
	if ($om >= 60)
	{
		$om = $om -60;
		$oh = $oh + 1;
		if ($oh >= 24)
		{
			$oh = $oh -24;
			$od = $od + 1;
		}
	}
	return ($od, $oh, $om);
}

sub dailyCurve {
	my ($oh, $om)= @_;
	my $xi = ($om/10) + $oh*6;
	my $tvar = (int(rand(20)) - 9)/200;
	my $hvar = (int(rand(20)) - 9)/200;
	
	$te = int(22 + 8*cos(($xi - 96)*pi*2/144)) +273;
	$hu = 0.55 + 0.2*cos(($xi - 96)*pi*2/144);
	
	$hu = $hu*(1+$hvar);
	
	return ($hu, $te);
}