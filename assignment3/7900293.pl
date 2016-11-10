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

# Get command-line arguments
if (!($grammarPath = $ARGV[0])) {
  die "\t!!! Original grammar needed as 1st command-line argument\n";
}
print "Grabbing original grammar found at $grammarPath\n";

if (!open($grammarFile, '<:encoding(UTF-8)', $grammarPath)) {
  die "\t!!! Could not find grammar file ($grammarPath)";
}
print "Grabbed grammar\n\n";

$outputPath = $ARGV[1];
if (!$outputPath) {
  $outputPath = $grammarPath =~ s/\.txt$/_out.txt/ri;
}


# Parse grammar
%errors;
%grammar;
while (my $line = <$grammar>) {
  $lineNumber++;
  chomp $line;

  if ($line !~ m/^\s*([A-Z][a-zA-Z]*)(\s+)(-+>).*/) { # error in left-hand side
    if ($line !~ m/^\s*([A-Z][a-zA-Z]*)(.*)/) {
      push (@{$errors{'Left factor is wrongly formatted'}}, $lineNumber);
    }
    if ($2 !~ m/^\s+(.*)/) {
      push (@{$errors{'Missing space between terms'}}, $lineNumber);
    }
    $arrow = $2 ? $2 : $1;
    if ($arrow !~ m/^-+>(.*)/) {
      push (@{$errors{'Arrow is wrongly formatted'}}, $lineNumber);
    }
    print "lol" . $2 . "lol";
  }
}

if (%errors) {
  print "Wrong format for input grammar:\n";

  foreach $key (sort keys %errors) {
    $lineNumbers = join(", ", @{$errors{$key}});
    print "\t$key on line(s) $lineNumbers\n";
  }

  print "\n";
}



# if errors in grammar, correct it
# output corrected grammar to $outputfile
