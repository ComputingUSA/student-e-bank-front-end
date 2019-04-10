#!perl
use CGI::Session;
use CGI;

my $cgi=new CGI();
my $session; my $cookie;
my   $sd =$cgi->cookie("CGISESSID") || undef;
 $session = new CGI::Session(undef,  $sd,  {Directory=>"/temp"});
$session->delete();
print<<EF;
Content-type: text/html

<html><head><title>Phoenix Online Banking</title></head>
<body>
<table border=0 width=100% cellpadding=0 cellspacing=0><tr><td>
<img src="/Team1/PhoenixLogo.gif"><img src="/Team1/PhoenixLogoLine.gif" height=50 width=50%>
</td></tr></TABLE><p>
<table><tr><th align=left>
Thank You for Using Phoenix Online Banking.</th></tr><p>
<tr><th align=left>You have successfully logged off from Phoenix Online Banking.</th></tr><p>  
<tr><th align=left>For your security we recommend you close your browser. </th></tr>
</table>
</body>
</html>
EF
