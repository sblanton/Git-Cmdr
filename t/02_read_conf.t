#!/usr/bin/perl

#use Git::Cmdr::Container;
#
#my $cntr = Git::Cmdr::Container->new(
#	repo_dir => '.'
#);
#
#my $svc = $cntr->resolve(service => 'git_cmdr');
#
#$svc->exec('status -sb');

use Config::GitLike;


my $c2 = Config::GitLike->load_file( '.02_gitconfig');

use Data::Dumper;
print Dumper($c2);

#$c2->dump;
