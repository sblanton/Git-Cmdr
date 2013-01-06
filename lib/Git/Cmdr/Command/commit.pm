package Git::Cmdr::Command::commit;

use strict;
use Carp qw(confess);


sub execute {
	my $s = shift or confess;
	my @gargs = @_;

	return "git commit -v @gargs";

}


{
	no warnings;
	*c  = \&commit;
}

1;
