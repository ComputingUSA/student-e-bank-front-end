#!perl
use strict;
use CGI;
use DBD::XBase;
use DBI;
use CGI::Session;

my $cgi=new CGI();
my $session; my $cookie;
my $dbh; my $sth; my $sth1;
my @account1; my @account2;
my $sa; my $ch;
my $userid="";

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
  {my $sql="select  sanum from Saving_Account  where userid = ? ";
    my $sql1="select chnum from Checking_Account  where userid = ? ";
   $sth=$dbh->prepare($sql);
   if($sth->execute($userid))
       {  while (@account1=$sth->fetchrow()) {
          $sa=$account1[0];}
          #close statement handle
          $sth->finish();
           $sth1=$dbh->prepare($sql1);
          if($sth1->execute($userid))
            {  while (@account2=$sth1->fetchrow()) {
          $ch=$account2[0];}
          #close statement handle
          $sth1->finish();} 
          else
              {print "cannot execute: ".$sth->errstr();}
print<<EF;
<html><head><title>Phoenix Banking</title>
<script language="javascript">
function validateForm ( form )
  {option1=form.From.options[form.From.selectedIndex].text;
  if (option1 == "Select account to deposit" )
     { alert("You didn't select a account!");
        return false;
         }
 if (form.to.value == "" )
     { alert("You should tell us your check number!");
        return false;
         }
if (isNaN(parseFloat(form.Amount.value))){
alert ("Please correct your amount value!");
return false;}
return true;

}
</script>
</head><body>
<table border=0 width=100% cellpadding=0 cellspacing=0><tr><td>
<img src="/Team1/PhoenixLogo.gif"><img src="/Team1/PhoenixLogoLine.gif" height=50><a href="/cgi-bin/Team1/logoff.pl"><img src="/Team1/PhoenixLogOff.gif" border=0></A>
</td></tr></TABLE>
<form action="/cgi-bin/Team1/depositDB.pl" onSubmit="return validateForm(this)">
<PRE>
<b>Make A Deposit

Select the Accounts to be used for the deposit, enter the deposit Amount. 

</b>
<table width="100%" cellspacing=0>
<tr height="30"><td width="1%" >
         <b>From: </b></td> <td  >
             <select name="From" id="frm">
                 <option>Select account to deposit
                  <option>Checking(#$ch)
                  <option>Saving(#$sa)
             </select>
         </td></tr>

</table>
<b>Routing,Account and Check Number (numbers on bottom of check)</b></label><input type="text" name="to" id="to" size="30">

<label for="amt"><b>Payment Amount: \$</b></label><input type="text" name="Amount" id="amt" size="18">

 <input type="button" value="Cancel" onclick="location='/cgi-bin/Team1/main.pl'">  <input type="submit" value="Continue">
</PRE>
</form>
</body>
</html>
EF
}
 else
     {print "cannot execute: ".$sth->errstr();}
  }
else
  {print "Couldn't connect: ".$DBI::errstr;}

#close database handle
$dbh->disconnect();
