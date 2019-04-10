#!perl
use strict;
use CGI;
use DBD::XBase;
use DBI;
use CGI::Session;

my $cgi=new CGI();
my $session; my $cookie;
 my $fr;
my $dbh; my $sth; my $stha;
my @account2; my @account1;
my @sa; my @ch; my $update1;
my $userid="";
my $fromacc=$cgi->param("From");
my $to=$cgi->param("to");
my $amt=$cgi->param("Amount");
my $newbal1;  my $update1;
my   $sd =$cgi->cookie("CGISESSID") || undef;
$session = new CGI::Session(undef,  $sd,  {Directory=>"$ENV{TEMP}"});

  $userid = $session->param("userid");
  if( $userid eq "" ){
print "content-type:text/html\n\n";
print<<EF;
Your session has expired! Click&nbsp<a href=\"/Team1/login.html\">here</a> to login again!.
EF
 exit;}   
 $cookie = $cgi->cookie(CGISESSID => $session->id);
 $session->expire("+2m");        
 print $cgi->header( -cookie => $cookie ) ; 

if($dbh=DBI->connect("DBI:XBase:c:/program files/Indigoperl/bank"))
  {my $ss="select  sanum, savingbal from Saving_Account  where userid = ? ";
    my $ss1="select chnum, chbal from Checking_Account  where userid = ? ";
   $sth=$dbh->prepare($ss);
   if($sth->execute($userid))
       {  while (@account1=$sth->fetchrow()) {
          @sa=@account1;}
          #close statement handle
          $sth->finish();}
        else
              {print "cannot execute: ".$sth->errstr();}
           $stha=$dbh->prepare($ss1);
          if($stha->execute($userid))
            {  while (@account2=$stha->fetchrow()) {
         @ch=@account2;}
          #close statement handle
          $stha->finish();} 
         else
              {print "cannot execute: ".$stha->errstr();}
        
            if ( $fromacc eq "Saving(#".$sa[0].")" ) {
                if ($amt > $sa[1]) {
print<<EF;
You don't have enough balance for this transfer!<a href=\"/cgi-bin/Team1/main.pl\">Click here</a> to try again.
EF
exit; } 
        else {$fr=$sa[0]; 
                $newbal1= $sa[1]-$amt;
                $update1 = " update Saving_Account set savingbal= ? where userid = ? ";   } }
  else { #don't need to check if it's checkNum since it has been done by sql and data validation
                if ($amt > $ch[1]) {
print<<EF;
You don't have enough balance for this transfer!<a href=\"/cgi-bin/Team1/main.pl\">Click here</a> to try again.
EF
 exit; } 
           else {$fr=$ch[0]; 
                 $newbal1=$ch[1]-$amt;
                  $update1= " update Checking_Account set chbal= ? where userid = ? "; } }
             my $sth = $dbh->prepare($update1);
             $sth->execute($newbal1, $userid);
             $sth->finish();
       my $d=do gdate();
    my $insert1="INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance) VALUES (?, ?, 'Payment to #$to', ?,0,?)";
         my $sth1 = $dbh->prepare($insert1);
             $sth1->execute($fr, $d, $amt,  $newbal1) or print "Can't execute!";
             $sth1->finish();
print<<EF;
<p>Your payment is complete. Thank you!<a href=\"/cgi-bin/Team1/main.pl\">Click here</a> to go to main page.
EF

  }
else
  {print "Couldn't connect: ".$DBI::errstr;}


#close database handle
$dbh->disconnect();

sub gdate {
      my @t=localtime;
     return sprintf "%02d/%02d/%d", $t[4]+1, $t[3], $t[5]+1900; }
