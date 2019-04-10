#!perl
use strict;
use CGI;
use DBD::XBase;
use DBI;
use CGI::Session;
 my $session; my $cookie;
my $cgi=new CGI();
my $dbh; my $sth; 
my @account;
my $userid;
my   $sd =$cgi->cookie("CGISESSID") || undef;
$session = new CGI::Session(undef,  $sd,  {Directory=>"$ENV{TEMP}"});
 $cookie = $cgi->cookie(CGISESSID => $session->id);
 $session->expire("+2m");        
 print $cgi->header( -cookie => $cookie ) ;
  $userid = $session->param("userid");
  if( $userid eq "" ){
print<<EF;
Your session has expired! Click&nbsp<a href=\"/Team1/login.html\">here</a> to login again!.
EF
 exit;}
my $sth1;
my $accnum=$cgi->param("an");
my $acct=$cgi->param("at");
my $total=0;
my @account;
my @account1;
if($accnum eq ""){ print "<html><body><font color=red>No information has been submitted!/font></body></html>\n"; 
exit;}
my ($frdate, $todate)=do  getFromToDate($accnum);
 print<<EF;
 <html><head><title>Chase Online Banking</title></head>
<body>
<table border=0 width=100% cellpadding=0 cellspacing=0><tr><td> <img src="/Team1/PhoenixLogo.gif"><img src="/Team1/PhoenixLogoLine.gif" height=50><a href="/cgi-bin/Team1/logoff.pl"><img src="/Team1/PhoenixLogOff.gif" border=0></A></td></tr></TABLE>
<FORM>
<INPUT TYPE=BUTTON OnClick="location='/cgi-bin/Team1/main.pl'" VALUE="My Accounts">&nbsp;&nbsp;
<INPUT TYPE=BUTTON OnClick="location='/cgi-bin/Team1/transfer.pl'" VALUE="Transfer"><P>
<INPUT TYPE=BUTTON   OnClick="location='/cgi-bin/Team1/payment.pl'" VALUE="Make payment">&nbsp;&nbsp;
<INPUT TYPE=BUTTON  OnClick="location='/cgi-bin/Team1/deposit.pl'" VALUE="Deposit">&nbsp;&nbsp;
</FORM>
<TABLE BORDER=0 WIDTH=60% CELLSPACNIG=0 CELLPADDING=0>
<TR><TD COLSPAN=5 ALIGN=LEFT>Account Detail</TD></TR>
<TR><TD COLSPAN=5>&nbsp;</TD></TR>
<TR><TD COLSPAN=5 ALIGN=LEFT>$acct (#$accnum)</TD></TR>
<TR><TD COLSPAN=5>&nbsp;</TD></TR>
<TR><TD COLSPAN=5 ALIGN=LEFT>From:$frdate&nbsp&nbsp;&nbsp;
To:  $todate&nbsp;&nbsp;&nbsp;
</TD></TR>
<TR><TH ALIGN=LEFT>Date</TH><TH ALIGN=LEFT>Transaction Type</TH>
<TH ALIGN=RIGHT>Debit</TH><TH ALIGN=RIGHT>Credit</TH>
<TH ALIGN=RIGHT>Balance</TH></TR><p>
EF
my $chk=0;
 my $cnn=0;
 my $color="#FFFFFF";
if($dbh=DBI->connect("DBI:XBase:c:/program files/Indigoperl/bank"))
  {
my $sql="select accnum, trandate, trantype, debit, credit, balance";
         $sql=$sql." from transaction  where accnum = ?";
   $sth=$dbh->prepare($sql);
   if($sth->execute($accnum))
       { 
      while (@account=$sth->fetchrow())
          { ++$cnn;
     $chk=$account[5];
      if ($cnn % 2==0){ $color="#C0C0C0";} else {$color="#FFFFFF";}
      
        print "<tr bgcolor=";print "$color"; print ">";
           print<<EF;
                  <td  align=left>\$$account[1]</td>     
                  <td align="left">  $account[2] </td>               
                <td align="right"> \$$account[3]  </td>                   
                <td align="right">\$$account[4]</td>
               <td align="right">\$$account[5]</td>
   </tr>
EF
  }

       print<<EF;
       <tr colspan=5  height="40"><th>Available Balance:</th><td> \$ $chk</td></tr>
</Table>
</html>
EF

     }
else
     {print "cannot execute: ".$sth->errstr();}
  }
else
  {print "Couldn't connect: ".$DBI::errstr;}

#close statement handle
$sth->finish();
$sth1->finish();
#close database handle
$dbh->disconnect();

sub getFromToDate{
my $from="";
my $to="";
my $account;
my $sth;
my $dbh=DBI->connect("DBI:XBase:c:/program files/Indigoperl/bank") or die $DBI::errstr;
my $sql="select trandate from transaction  where accnum = ?";
   $sth=$dbh->prepare($sql);
   if($sth->execute($_[0]))
       {  while ($account=$sth->fetchrow()){
      if ($from ge $account || $from eq "") { $from=$account;}
      if($to le $account ||  $to eq ""){$to=$account;}}
}
else
     {print "cannot execute: ".$sth->errstr();}
 $sth->finish();
$dbh->disconnect();
return ($from, $to);}

