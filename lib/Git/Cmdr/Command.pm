package Git::Cmdr::Command;
use App::Cmd::Setup -command;

use App::Services::Log::Container;
with App::Services::Log::Role;

use Moo;
use Carp qw(confess);
use common::sense;

use Cwd;
use Config::GitLike::Git;

has log_conf => (
	is      => 'rw',
	default => sub {
		\qq/ 
log4perl.rootLogger=INFO, stdout
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%m%n
/;
	},
);

sub BUILD {
	my $s = shift;

	my $log_cntnr = App::Services::Logger::Container->new(
		log_conf => $s->log_conf,
		name     => 'log'
	);

	$s->update;
	return $s;
}

has work_tree => ( is => 'rw', );
has workspace => ( is => 'rw', );

sub exec {
	my $s = shift or die;

	my $directive = shift;
	my @args      = @_;

	return $s->help unless ($directive);
	
	unless ($s->git_env->verify) {
		$s->log->error("Current directory is not part of a Git work tree");
		exit 1;
	}

	my $git_cmd;

	if ( $s->git_cmd->can($directive) ) {
		$git_cmd = $s->git_cmd->$directive(@args);

	} elsif ( $s->git_pragma->can($directive) ) {
		return $s->git_pragma->$directive(@args);

	} else {
		$git_cmd = "git $directive @args";

	}

	map { $_ =~ s/\s*$//; $s->log->info($_) } $s->_exec($git_cmd);

}

sub _exec {
	my $s = shift or confess;

	my $git_cmd = shift or $s->log->logconfess();

	$s->log->info("($git_cmd)");

	return `$git_cmd`;
}

sub git_dir {
	return $_[0]->work_tree . '/.git';
}

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

sub verify {
	my $s = shift or confess;
	return unless $s->update_work_tree;
}

sub update {
	my $s = shift or confess;
	return unless $s->update_work_tree;
	return $s->update_repos;
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
