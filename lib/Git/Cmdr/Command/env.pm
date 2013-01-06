package Git::Cmdr::env;

use common::sense;
use Carp qw(confess);

sub execute {
	my $s = shift or confess;

	my $log = $s->log;

	$log->info( "Current Git Work Tree: " . $s->git_env->work_tree );
	$log->info( "Current Git Dir: " . $s->git_env->git_dir );
	$log->info( "Current Git-Cmdr Workspace: " . $s->git_env->workspace );
	$log->info( "Current Workspace Git Repos: ");

	map { $log->info("\t$_") } @{ $s->git_env->repos };

}

1;
