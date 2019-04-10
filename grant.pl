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
<body>

<table border=0 width=100% cellpadding=0 cellspacing=0><tr><td><img src="/Team1/PhoenixLogo.gif"><img src="/Team1/PhoenixLogoLine.gif" height=50%><a href="/cgi-bin/Team1/logoff.pl"><img src="/Team1/PhoenixLogOff.gif" border=0></A></td></tr></table>
<h1>Add details for $userid</h1>
<FORM name="input" action="/cgi-bin/Team1/adduser.pl">	
<table>
<tr><th align=right>Desired User ID</th><td align=left><input type="text" name=userid value=\"$userid\" size=20></td></tr>
<tr><th align=right>Checking Account Number</th><td align=left><input type="text" name=checknum value="" size=20></td></tr>
<tr><th align=right>Checking Account Balance</th><td align=left><input type="text" name=checkbal value="" size=20></td></tr>
<tr><th align=right>Savings Account Number</th><td align=left><input type="text" name=savnum value="" size=20></td></tr>
<tr><th align=right>Savings Account Balance</th><td align=left><input type="text" name=savbal value="" size=20></td></tr>
<tr><th align=center colspan=2><input type="Submit" value="Submit"></td></tr>
</table>
</form>
</body></html>
EOT

