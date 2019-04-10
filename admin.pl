#!perl
# cgi script
use DBI;
use CGI;
use CGI::Session;

my $cgi = new CGI;
my $dbh = DBI->connect("DBI:XBase:C:/Program Files/IndigoPerl/bank");

my $sth = $dbh->prepare("select userid,password,privilegele from login where privilegele=\"new\"");
$sth->execute();

my @data;
my $priv;
my $pr;
my $u;
my $p;

print $cgi->header();

print <<EOT;
<html><head><title>Phoenix Online Banking</title></head>
<body>
<h1>New Users</h1>
EOT

print "<p>New Users requesting access:<p>Click to grant/reject access.<p>";
while (@data = $sth->fetchrow_array()) {
	($u,$p,$pr)=@data;

	print("<p>User <b>$u:</b> <a href=/cgi-bin/Team1/view.pl?userid=$u>View</a> <a href=/cgi-bin/Team1/grant.pl?userid=$u>Grant</a> <a href=/cgi-bin/Team1/reject.pl?userid=$u>Reject</a>.<p>");
}

print "</body></html>";
