package Git::Cmdr::Pragmas;

use common::sense;
use Carp qw(confess);

use Moo;

with 'App::Services::Logger::Role';

has git_env => ( is => 'rw' );

sub env {
	my $s = shift or confess;

	my $log = $s->log;

	$log->info( "Current Git Work Tree: " . $s->git_env->work_tree );
	$log->info( "Current Git Dir: " . $s->git_env->git_dir );
	$log->info( "Current Git-Cmdr Workspace: " . $s->git_env->workspace );
	$log->info( "Current Workspace Git Repos: ");

	map { $log->info("\t$_") } @{ $s->git_env->repos };

}

sub info {
	my $s = shift or confess;

}

no Moo;

1;
