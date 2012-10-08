package Git::Cmdr::Pragmas;

use common::sense;
use Carp qw(confess);

use Moo;

sub update {
	my $s = shift or confess;
	my @gargs = @_;
	
	return "git add -v @gargs";
	
}

no Moo;

1;
