#! /usr/bin/perl

# CSI 3520 Devoir 3
# Nom de l'élève : Jonathan Guillotte-Blouin
# Nombre d'étudiants : 7900293
# Courriel d’étudiant: jguil098@uottawa.ca

use Data::Dumper qw(Dumper);

# helper functions
sub trim {
  my $inputString = $_[0];

  my $trimmedString = $inputString =~ s/^(\s*)(\S|\S.*\S)(\s*)$/\2/r;
  return $trimmedString;
}

sub showErrorMsg {
  my ($errorMsg, $line) = @_;

  print "Wrong format for input grammar:\n";
  print "--> " . $errorMsg;

  if ($line) {
     print " on line " . $line;
  }
  print "\n\n";

  die;
}

sub findError {
  my ($str, $line, $rightPadding) = @_;
  $trimmedStr = trim($str);

  if ($str !~ /^\s+(?:\S.*)/) {
    showErrorMsg("Missing padding on the left of subterm ($trimmedStr)", $line);
  }

  if ($rightPadding && $str !~ /(?:.*\S)\s+$/) {
    showErrorMsg("Missing padding on the right of subterm ($trimmedStr)", $line);
  }

  @splitStr = split(/\s+/, $trimmedStr);
  foreach my $subTerm (@splitStr) {
    if ($subTerm !~ /^(?:[A-Z]\S*|[^\sA-Z]+)$/) {
      $badTerm .= $badTerm ? " $subTerm" : $subTerm;
    }
  }

  showErrorMsg("Wrongly formatted subterms ($badTerm)", $line);
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

  if ($2 !~ m/^\s+(.*)/) {
    showErrorMsg("Missing space between terms", $lineNumber);
  }
  $arrowAndRightHand = $1;

  if ($arrowAndRightHand !~ m/^-+>(.*)/) {
    showErrorMsg("Arrow is wrongly formatted", $lineNumber);
  }
  @rightHand = split(/\|/, $1);

  # loop through righthand, check and parse every term
  for my $i (0 .. $#rightHand) {
    $term = $rightHand[$i];

    # right-hand wrongly formatted or not
    if ($i == $#rightHand) {
      if ($term !~ /^(?:\s+(?:[A-Z]\S*|[^\sA-Z]+))+\s*$/) {
        findError($term, $lineNumber, 0);
      }
    } else {
      if ($term !~ /^(?:\s+(?:[A-Z]\S*|[^\sA-Z]+))+\s+$/) {
        findError($term, $lineNumber, 1);
      }
    }

    my @subTerms = split(/\s+/, trim($term));
    push @{$grammar{$leftTerm}}, \@subTerms;
  }
}


# check if all non-terminals on the right-hand have a production
@productionKeys = keys %grammar;
foreach my $key (@productionKeys) {
  @production = @{$grammar{$key}};

  for my $term (@production) {
    for my $subTerm (@{$term}) {
      if ($subTerm =~ /^[A-Z]/ && !exists $grammar{$subTerm}) {
        showErrorMsg("Terminal ($subTerm) has no production");
      }
    }
  }
}


# check and correct direct left-recursivity
$hasChanged = 0; # flag to know if a change was made

foreach my $key (@productionKeys) {
  @production = @{$grammar{$key}};
  my @alphas = ();
  my @betas = ();
  $newKey = "$key'";

  for my $term (@production) {
    if (@{$term}[0] eq $key) {
      @termArr = @{$term};
      my @alpha = @termArr[1 .. $#termArr];
      push @alpha, $newKey;

      if (@alpha) {
        push(@alphas, \@alpha);
      }
    } else {
      my @beta = @{$term};
      push @beta, $newKey;

      push(@betas, \@beta);
    }
  }

  if (@alphas) {
    my @epsilon = qw(ε);
    push @alphas, \@epsilon;

    @{$grammar{$key}} = @betas;
    @{$grammar{$newKey}} = @alphas;
  }
}

print Dumper \%grammar;


# check and correct left-factor


# output corrected grammar to $outputfile
