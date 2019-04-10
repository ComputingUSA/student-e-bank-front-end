#!perl
# cgi script
use DBI;
use CGI;
use CGI::Session;

my $cgi = new CGI;
my $dbh = DBI->connect("DBI:XBase:C:/Program Files/IndigoPerl/bank");

print $cgi->header();
my $userid = $cgi->param('userid');

my $sth = $dbh->prepare("select Lname,Fname,DOB,SSN,Address,Homephone,Email from customer where userid=\"$userid\"") or print "SQL error";
$sth->execute();

my @data;

print <<EOT;
<html><head><title>Phoenix Online Banking</title></head>
<body>
<h1>New User Profile</h1>
EOT

@data = $sth->fetchrow_array();
($lname,$fname,$dob,$ssn,$address,$homephone,$email)=@data;
 
	print("<table border=8><tr><td>User Id</td><td>$userid</td></tr>");
	print("<tr><td>Last Name</td><td>$lname</td></tr>");
 	print("<tr><td>First Name</td><td>$fname</td></tr><p>");
	print("<tr><td>Date of Birth</td><td>$dob</td></tr>");
	print("<tr><td>Social Security Number</td><td>$ssn</td></tr>");
	print("<tr><td>Address</td><td>$address</td></tr>");
	print("<tr><td>Home Phone</td><td>$homephone</td></tr>");
	print("<tr><td>Email Address</td><td>$email</td></tr>");

print "</table><a href=\"/cgi-bin/Team1/admin.pl\">Back</a> to Administrators menu.</body></html>";
