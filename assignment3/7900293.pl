# CSI 3520 Devoir 3
# Nom de l'élève : Jonathan Guillotte-Blouin
# Nombre d'étudiants : 7900293
# Courriel d’étudiant: jguil098@uottawa.ca

# helper functions
sub trim {
  my $inputString = $_[0];

  my $trimmedString = $inputString =~ s/^(\s*)(\w|\w.*\w)(\s*)$/\2/r;
  return $trimmedString;
}

sub showErrorMsg {
  my ($errorMsg, $line) = @_;

  print "Wrong format for input grammar:\n";
  print "--> " . $errorMsg . " on line " . $line . "\n\n";
  die;
}

# Get command-line arguments
if (!($grammarPath = $ARGV[0])) {
  die "--> Original grammar needed as 1st command-line argument\n";
}
print "Grabbing original grammar found at $grammarPath\n";

if (!open($grammarFile, '<:encoding(UTF-8)', $grammarPath)) {
  die "--> Could not find grammar file ($grammarPath)";
}
print "Grabbed grammar\n\n";

$outputPath = $ARGV[1];
if (!$outputPath) {
  $outputPath = $grammarPath =~ s/\.txt$/_out.txt/ri;
}


# Parse grammar
%grammar;
while (my $line = <$grammarFile>) {
  $lineNumber++;
  my $leftTerm;
  chomp $line;

  if ($line !~ m/^\s*([A-Z][a-zA-Z]*)(.*)/) {
    showErrorMsg("Left factor is wrongly formatted", $lineNumber);
  }
  $leftTerm = $1;

  if (exists $grammar{$leftTerm}) {
    showErrorMsg("Non-terminal production can be present only once", $lineNumber);
  }
  $grammar{$leftTerm} = ();

  if ($2 !~ m/^\s+(.*)/) {
    showErrorMsg("Missing space between terms", $lineNumber);
  }
  $arrowAndRightHand = $1;

  if ($arrowAndRightHand !~ m/^-+>(.*)/) {
    showErrorMsg("Arrow is wrongly formatted", $lineNumber);
  }
  @rightHand = split('|', $1);

  # loop through righthand, check and parse every term
}



# if errors in grammar, correct it

# output corrected grammar to $outputfile
