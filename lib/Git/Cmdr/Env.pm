package Git::Cmdr::Env;

use Moo;

use Cwd;

has curr_work_tree => (
 is => 'ro',
);

has curr_repos => (
	traits => ['Array'],
	is     => 'rw',
	isa    => 'ArrayRef',

	auto_deref => 1,
	handles    => {
		all_curr_repos        => 'elements',
		push_curr_repos       => 'push',
		shift_curr_repos      => 'shift',
		map_curr_repos        => 'map',
		filter_curr_repos     => 'grep',
		find_curr_repos       => 'first',
		get_curr_repos        => 'get',
		join_curr_repos       => 'join',
		count_curr_repos      => 'count',
		has_curr_repos        => 'count',
		has_no_curr_repos     => 'is_empty',
		sort_curr_repos       => 'sort',
		clear_curr_repos      => 'clear',
		delete_curr_repos     => 'delete',
	},
	default => sub { [] },
	lazy => 1,

);

sub update {
	my $s = shift or die;

	my $orig_cwd = getcwd();
	my $cwd = $orig_cwd;

	while ( ! -d '.git' and $cwd = getcwd() ne '/' ) { chdir('..') }
	
	return $s->curr_work_tree( $cwd ) unless $cwd eq '/';
	
	opendir(my $h_curr_dir, '.') or die;
	
	my @folders = readdir($h_curr_dir);
	
	@folders = grep !/^.{1,2}/, @folders;

	foreach my $folder ( @folders ) {
		if ( -d $folder and -d "$folder/.git" ) {
	

		}
	}	
	
};


1;
