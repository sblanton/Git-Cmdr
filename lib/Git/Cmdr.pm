# ABSTRACT: Makes Git easy 

package Git::Cmdr;

use common::sense;
use Carp qw(confess);

use Moo;

with('App::Services::Logger::Role');

has git_env    => ( is => 'rw', );
has git_cmd    => ( is => 'rw', );
has git_pragma => ( is => 'rw', );

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

sub env {
	my $s = shift or die;

	$s->log->info("\"gc env\": Git Environment");
	$s->log->info( "\tGit Work Tree\t: " . $s->git_env->work_tree );

	if ( @{ $s->git_env->repos } ) {
		$s->log->info( "\tGit Workspace\t: " . $s->git_env->workspace );
		$s->log->info("\tGit Repos\t: @{$s->git_env->repos}");

	}

}

sub help {
	my $s = shift or die;

	$s->log->error("No git directive passed!");

}

no Moo;

1;
