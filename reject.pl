#!perl
# cgi script
use DBI;
use CGI;
use CGI::Session;

my $cgi = new CGI;
my $dbh = DBI->connect("DBI:XBase:C:/Program Files/IndigoPerl/bank");

$userid = $cgi->param('userid');

print $cgi->header();
print <<EOT;
<html><head><title>Phoenix Online Banking</title></head>
<table border=0 width=100% cellpadding=0 cellspacing=0><tr><td><img src="/Team1/PhoenixLogo.gif"><img src="/Team1/PhoenixLogoLine.gif" height=50%><a href="/cgi-bin/Team1/logoff.pl"><img src="/Team1/PhoenixLogOff.gif" border=0></A></td></tr></table>
<body>
EOT

my $sth;

print "<p>Removing $userid<p>";

#delete a userid
$sth = $dbh->prepare("delete from login where userid=\"$userid\" AND privilegele=\"new\"") or print "sql error";
$sth->execute();
$sth = $dbh->prepare("delete from customer where userid=\"$userid\"") or print "sql error";
$sth->execute();

print "Return to <a href=/cgi-bin/Team1/admin.pl>Administrator screen</a>.</body></html>"

