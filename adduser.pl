#!perl
# cgi script
use DBI;
use CGI;
use CGI::Session;

my $cgi = new CGI;
my $dbh = DBI->connect("DBI:XBase:C:/Program Files/IndigoPerl/bank");

$userid = $cgi->param('userid');
$checknum = $cgi->param('checknum');
$checkbal = $cgi->param('checkbal');
$savnum = $cgi->param('savnum');
$savbal = $cgi->param('savbal');

print $cgi->header();
print <<EOT;
<html><head><title>Phoenix Online Banking</title></head>
<table border=0 width=100% cellpadding=0 cellspacing=0><tr><td><img src="/Team1/PhoenixLogo.gif"><img src="/Team1/PhoenixLogoLine.gif" height=50%><a href="/cgi-bin/Team1/logoff.pl"><img src="/Team1/PhoenixLogOff.gif" border=0></A></td></tr></table>
<body>
EOT

my $sth;
my $d=do gdate();

#add accounts of there is data supplied
if ( $checknum ne "") {
  $sth = $dbh->prepare("insert into Checking_Account values (\"$userid\",\"$checknum\",\"$checkbal\",\"open\",\"$d\")") or print "sql error";
  $sth->execute();
  $sth = $dbh->prepare("INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) VALUES (\"$checknum\",\"$d\",'Initial Balance',0 ,\"$checkbal\",\"$checkbal\")") or print "sql error";
  $sth->execute();
}
if ( $savnum ne "") {
  $sth = $dbh->prepare("insert into Saving_Account values (\"$userid\",\"$savnum\",\"$savbal\",\"open\",\"$d\")") or print "sql error";
  $sth->execute();
  $sth = $dbh->prepare("INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) VALUES (\"$savnum\",\"$d\",'Initial Balance',0 ,\"$savbal\",\"$savbal\")") or print "sql error";
  $sth->execute();
}

#activate user by setting privilege level from "new" to "cust"
$sth = $dbh->prepare("update login set Privilegele= \"cust\" where userid  =\"$userid\"");
$sth->execute();

print <<EOT;
<h1>Adding $userid</h1><p>
Checking Account #$checknum<p>
Checking Balance \$$checkbal<p>
Savings Account #$savnum<p>
Savings Balance \$$savbal<p>

Go back to <a href=/cgi-bin/Team1/admin.pl>Administrator screen</a>.
</body></html>
EOT

sub gdate {
      my @t=localtime;
     return sprintf "%02d/%02d/%d", $t[4]+1, $t[3], $t[5]+1900;
}

