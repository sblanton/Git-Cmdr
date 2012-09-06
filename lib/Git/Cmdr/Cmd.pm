package Git::Cmdr::Cmd;

use common::sense;
use Carp qw(confess);

use Moo;
with 'App::Services::Logger::Role';

has git_env => ( is => 'rw', );
has git_cmd => ( is => 'rw', );

sub exec {
	my $s = shift or die;

	my $directive = shift;
	my @args      = @_;

	unless ($directive) {
		$s->help;
		exit 1;
	}

	if ( $s->can($directive) ) {
		$s->$directive(@args);

	} else {
		my $git_cmd = "git $directive @args";
		map { $_ =~ s/\s*$//; $s->log->info($_) } $s->_exec($git_cmd);

	}

}

sub _exec {
	my $s = shift or confess;

	my $git_cmd = shift or $s->log->logconfess();
	
	$s->log->info("'$git_cmd':");

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


sub add {
	my $s = shift or confess;
	my @gargs = @_;
	
	my $git_cmd = "git add -v @gargs";

	map { $_ =~ s/\s*$//; $s->log->info($_) } $s->_exec($git_cmd);
	
}

sub status {
	my $s = shift or confess;
	
	my $git_cmd = "git status -sb";

	map { $_ =~ s/\s*$//; $s->log->info($_) } $s->_exec($git_cmd);
	
}

sub help {
	my $s = shift or die;

	$s->log->error("No git directive passed!");

}

no Moo;

1;
