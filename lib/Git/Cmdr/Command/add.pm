package Git::Cmdr::Command::add;
use Git::Cmdr -command;

use strict;
use Carp qw(confess);

use Moo;

sub add {
	my $s = shift or confess;
	my @gargs = @_;

	return "git add -v @gargs";

}

sub commit {
	my $s = shift or confess;
	my @gargs = @_;

	return "git commit -v @gargs";

}

sub status {
	my $s = shift or confess;
	my @gargs = @_;

	return "git status -sb @gargs";

}

sub push {
	my $s = shift or confess;
	my @gargs = @_;

	return "git push -v @gargs";

}

{
	no warnings;
	*a  = \&add;
	*s  = \&status;
	*ps = \&push;
	*c  = \&commit;
}

no Moo;

1;
