package Git::Cmdr::Env;

use Moo;
use Carp qw(confess);
use common::sense;

use Cwd;
use Parse::PlainConfig;

sub BUILD {
	$_[0]->update;

}

has work_tree => ( is => 'rw', );
has workspace => ( is => 'rw', );

has repos => (
	is  => 'rw',
	isa => sub { die unless ref( $_[0] ) eq 'ARRAY' },
	default => sub { [] },

);

has user_properties => (
	is      => 'rw',
	default => sub {
		Parse::PlainConfig->new(
			'FILE'         => '~/.git-cmdr',
			'MAX_BYTES'    => 65536,
			'SMART_PARSER' => 1,
		);
	},
	lazy => 1
);

sub update {
	my $s = shift or confess;
	$s->update_work_tree;
	$s->update_repos;
}

sub update_user_properties {
	my $s = shift or confess;

}

sub update_work_tree {
	my $s = shift or confess;

	my $orig_cwd = cwd();
	my $cwd      = $orig_cwd;

	while ( !-d '.git' and $cwd ne '/' ) {
		chdir('..');
		$cwd = cwd();
	}

	chdir($orig_cwd);

	return $s->work_tree($cwd) unless $cwd eq '/';

	return undef;

}

sub update_repos {
	my $s = shift or confess;

	my $orig_cwd = cwd();

	chdir( $s->work_tree );
	chdir('..');
	$s->workspace( cwd() );

	opendir( my $h_dir, $s->workspace ) or die;

	my @folders = readdir($h_dir);

	@folders = grep !/^\./, @folders;

	foreach my $folder (@folders) {
		if ( -d $folder and -d "$folder/.git" ) {
			$s->repos( [ @{ $s->repos }, $folder ] );
		}
	}
	
	chdir($orig_cwd);

}

no Moo;

1;
