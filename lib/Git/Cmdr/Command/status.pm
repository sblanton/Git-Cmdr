package Git::Cmdr::Command::status;
use Git::Cmdr -command;

use strict;
use Carp qw(confess);

use Moo;

sub execute {
	my $s = shift or confess;
	my @gargs = @_;

	return "git status -sb @gargs";

}


{
	no warnings;
	*s  = \&status;
}

no Moo;

1;
