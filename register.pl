#!perl
# cgi script
use DBI;
use CGI;
use CGI::Session;


my $cgi = new CGI;
my $dbh = DBI->connect("DBI:XBase:C:/Program Files/IndigoPerl/bank");

print $cgi->header();
my $userid = $cgi->param('userid');
my $passwd = $cgi->param('passwd');
my $fname = $cgi->param('fname');
my $lname = $cgi->param('lname');
my $dob = $cgi->param('dob');
my $ssn = $cgi->param('ssn');
my $address = $cgi->param('address');
my $homephone = $cgi->param('homephone');
my $email = $cgi->param('email');

my $sth = $dbh->prepare("insert into login values (\"$userid\",\"$passwd\",\"new\")") or print "sql error";
$sth->execute();

$sth = $dbh->prepare("insert into customer values (\"$userid\",\"$fname\",\"$lname\",\"$dob\",\"$ssn\",\"$address\",\"$homephone\",\"$email\")") or print "sql error";
$sth->execute();

print <<EOT;
<html><head><title>Phoenix Online Banking</title></head>
<body>
<table border=0 width=100% cellpadding=0 cellspacing=0><tr><td><img src="/Team1/PhoenixLogo.gif"><img src="/Team1/PhoenixLogoLine.gif" height=50%><a href="/cgi-bin/Team1/logoff.pl"><img src="/Team1/PhoenixLogOff.gif" border=0></A></td></tr></table>
<title>Thank you</title>
<h2>Thank you for your application.</h2><P>
Your application should be processed in a days.<p></body></html>
EOT
