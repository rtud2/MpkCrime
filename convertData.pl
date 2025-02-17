use warnings;
use strict;

my @files = glob('data/*.pdf');


foreach my $fi (@files){
	system("pdftotext.exe -layout \'$fi\'");

}
