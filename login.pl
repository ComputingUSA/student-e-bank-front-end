#!perl
# cgi script
use DBI;
use CGI;
use CGI::Session;

my $cgi = new CGI;
my $dbh = DBI->connect("DBI:XBase:C:/Program Files/IndigoPerl/bank");

$userid = $cgi->param('userid');
$passwd = $cgi->param('passwd');
$authorized=0;

my $sth = $dbh->prepare("select userid,password,privilegele from login where userid=\"$userid\"");
$sth->execute();

my @data;
my $priv;
my $pr;

while (@data = $sth->fetchrow_array()) {
	($u,$p,$pr)=@data;

	if (($u eq $userid) && ($p eq $passwd))
	{
		$authorized=1;
    $priv=$pr;
	}
}

if ($authorized) {

my $session = new CGI::Session(undef, $cgi, {Directory=>"$ENV{TEMP}"});
my $cookie = $cgi->cookie(CGISESSID => $session->id);
$session->param("userid",$userid);

print $cgi->header( -cookie=>$cookie );

print <<EOT;
<html><head><title>Phoenix Online Banking</title></head>
<body>
<table border=0 width=100% cellpadding=0 cellspacing=0><tr><td><img src="/Team1/PhoenixLogo.gif"><img src="/Team1/PhoenixLogoLine.gif" height=50%><a href="/cgi-bin/Team1/logoff.pl"><img src="/Team1/PhoenixLogOff.gif" border=0></A></td></tr></table>
<title>Login Successful</title>
<h2>Welcome, $userid.</h2><P>
EOT

  if ($priv eq "cust") {
    print "<a href=main.pl>View Accounts</a></body></html>";
  }
  if ($priv eq "admin") {
    print "<a href=admin.pl>Administrator's Screen</a></body></html>";
  }
  if ($priv eq "new" ) {
    print "<p>Unfortunately your new application has not yet been approved. <p> Please <a href=/Team1/login.html>try again</a> later.</body></html>";
  }

} else {

print $cgi->header( );
print <<EOT;
<html><head><title>Login Unsuccessful</title></head>
<body>
<table border=0 width=100% cellpadding=0 cellspacing=0> <tr><td><img src="/Team1/PhoenixLogo.gif"><img src="/Team1/PhoenixLogoLine.gif" height=50> <a href="/cgi-bin/Team1/logoff.pl"><img src="/Team1/PhoenixLogOff.gif" border=0></A></td></tr></table>
<h2>Sorry, $userid. Your login was unsuccessful.<P>
Please <a href=/Team1/login.html>try again</a>.</html>
EOT
}
