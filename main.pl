#!perl
use strict;
use CGI;
use DBD::XBase;
use DBI;
use CGI::Session;

my $cgi=new CGI();
my $session; my $cookie;
my $total=0;
my $dbh; my $sth; my $sth1;
my @account1; my @account2;
my @sa; my @ch;
my $userid="";

my  $sd =$cgi->cookie("CGISESSID") || undef;
$session = new CGI::Session(undef,  $sd,  {Directory=>"$ENV{TEMP}"});

$userid = $session->param("userid");

  if( $userid eq "" ){
print "content-type:text/html\n\n";
print<<EF;
Your session has expired! Click&nbsp<a href=\"/Team1/login.html\">here</a> to login again!
EF
 exit;}   
 $cookie = $cgi->cookie(CGISESSID => $session->id);
 $session->expire("+2m");        
 print $cgi->header( -cookie => $cookie ) ;   
if($dbh=DBI->connect("DBI:XBase:c:/program files/Indigoperl/bank"))
  {my $sql="select userid, sanum, savingbal from Saving_Account  where userid = ? ";
     my $sql1="select  chnum, chbal from Checking_Account  where userid = ? ";
   $sth=$dbh->prepare($sql);
   if($sth->execute($userid))
       {  while (@account1=$sth->fetchrow()){
             @sa=@account1; }
        #close statement handle
         $sth->finish();}
   else
     {print "cannot execute: ".$sth->errstr();}
          $sth1=$dbh->prepare($sql1);
             if($sth1->execute($userid))
       {  while (@account2=$sth1->fetchrow()){
             @ch=@account2; }
        #close statement handle
         $sth1->finish();}
             else
             {print "cannot execute: ".$sth->errstr();}

print<<EF;
<html><head><title>Phoenix Online Banking</title></head><body>
   <table border=0 width=100% cellpadding=0 cellspacing=0><tr><td>
 <img src="/Team1/PhoenixLogo.gif"><img src="/Team1/PhoenixLogoLine.gif" height=50><a href="/cgi-bin/Team1/logoff.pl"><img src="/Team1/PhoenixLogOff.gif" border=0></A>
   </td></tr></TABLE>
  <Form >
      <input type="button" value="My Accounts" onclick="location='/cgi-bin/Team1/main.pl'">  
      <input type="button" value="Transfer" onclick="location='/cgi-bin/Team1/transfer.pl'">  
    <INPUT TYPE=BUTTON   OnClick="location='/cgi-bin/Team1/payment.pl'" VALUE="Make payment">&nbsp;&nbsp;
<INPUT TYPE=BUTTON  OnClick="location='/cgi-bin/Team1/deposit.pl'" VALUE="  Deposit  ">&nbsp;&nbsp;
  </Form>
     <table border=0  width ="40%" cellpadding=3 cellspacing=10>
         <tr><th width="70%" align="left">Deposit Accounts</th> <th                                                                   align="right">Balance</th></tr>
EF

if ( $ch[0] ne ""){
          print<<EF;
         <tr><td><a href=\"/cgi-bin/Team1/detail.pl?an=$ch[0]&at=checking\">Checking (#$ch[0])</a></td> <td align=right>\$ $ch[1]</td></tr>
EF
}
   else { $ch[1]=0;}
        if ($sa[1] ne ""){
 print<<EF;
         <tr><td ><a href=\"/cgi-bin/Team1/detail.pl?an=$sa[1]&at=saving\">Saving (#$sa[1]) </a></td> <td align=right>  \$ $sa[2]</td></tr>
EF
}
         else { $sa[2]=0;}
          $ total=$sa[2]+$ch[1];
print<<EF;
           <tr ><td colspan=2 align=right>  <b> Total</b>:    \$ $total</td></tr>
     </table>
    </body>
</html>
EF


  }
else
  {print "Couldn't connect: ".$DBI::errstr;}

#close database handle
$dbh->disconnect();
   
