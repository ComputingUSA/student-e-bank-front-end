#!perl
use strict;
use CGI;
use DBD::XBase;
use DBI;
use CGI::Session;

my $cgi=new CGI();
my $session; my $cookie;
my $dbh; my $sth; my $stha;
my @account2; my @account1;
my @sa; my @ch;
my $userid=""; my $fr; my $to;
my $fromacc=$cgi->param("From");
my $toacc=$cgi->param("To");
my $amt=$cgi->param("Amount");
my $newbal1; my $newbal2; my $update1;
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
                else {
                  $fr=$sa[0]; $to=$ch[0];
                  $newbal1= $sa[1]-$amt;
                  $newbal2=$ch[1]+$amt;
#from account is savings which is also newbal1
             $update1 = " update Saving_Account set savingbal= ? where userid = ? ";
             my $sth = $dbh->prepare($update1);
             $sth->execute($newbal1, $userid);
             $sth->finish();
           my  $update8= " update Checking_Account set chbal= ? where userid = ? ";
             my $stha= $dbh->prepare($update8);
             $stha->execute($newbal2, $userid);
             $stha->finish();
           my $d=do gdate();
           my $insert1="INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance)
                           VALUES (?, ?, 'Transfer', ?, null,?)";
           my $sth1 = $dbh->prepare($insert1);
             $sth1->execute($fr, $d, $amt, $newbal1) or print "Can't execute!";
             $sth1->finish();
           my $insert2= "INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance)
                        VALUES (?,?, 'Transfer',  null, ?, ?)";
           my $sth1 = $dbh->prepare($insert2);
             $sth1->execute($to, $d, $amt, $newbal2) or print "Can't execute!";
             $sth1->finish();
                }
            } else { #don't need to check if it's checkNum since it has been done by sql and data validation
                if ($amt > $ch[1]) {
print<<EF;
You don't have enough balance for this transfer!<a href=\"/cgi-bin/Team1/main.pl\">Click here</a> to try again.
EF
                  exit;
                } else {
#from account is checking and uses newbal2
                 $fr=$ch[0]; $to=$sa[0];
                  $newbal1= $sa[1]+$amt;
                 $newbal2=$ch[1]-$amt;
             $update1 = " update Saving_Account set savingbal= ? where userid = ? ";
             my $sth = $dbh->prepare($update1);
             $sth->execute($newbal1, $userid);
             $sth->finish();
           my  $update8= " update Checking_Account set chbal= ? where userid = ? ";
             my $stha= $dbh->prepare($update8);
             $stha->execute($newbal2, $userid);
             $stha->finish();
           my $d=do gdate();
           my $insert1="INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance)
                           VALUES (?, ?, 'Transfer', ?, null,?)";
           my $sth1 = $dbh->prepare($insert1);
             $sth1->execute($fr, $d, $amt, $newbal2) or print "Can't execute!";
             $sth1->finish();
           my $insert2= "INSERT INTO transaction (accnum, trandate, trantype, debit, credit, balance)
                        VALUES (?,?, 'Transfer',  null, ?, ?)";
           my $sth1 = $dbh->prepare($insert2);
             $sth1->execute($to, $d, $amt,  $newbal1) or print "Can't execute!";
             $sth1->finish();
                }
            }


print<<EF;
<p>Your transaction is complete. Thank you!<a href=\"/cgi-bin/Team1/main.pl\">Click here</a> to go to main page.
EF

  }
else
  {print "Couldn't connect: ".$DBI::errstr;}

#close database handle
$dbh->disconnect();

sub gdate {
      my @t=localtime;
     return sprintf "%02d/%02d/%d", $t[4]+1, $t[3], $t[5]+1900;
}
