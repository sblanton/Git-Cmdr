package Git::Cmdr::Container;

use Moo;
use Bread::Board;

extends 'Bread::Board::Container';

use App::Services::Logger::Container;
use Git::Cmdr;

has name => (
	is      => 'ro',
	default => sub { 'Git_Cmdr' },
);

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
	my $s = shift or die;

	my $log_cntnr = App::Services::Logger::Container->new(
		log_conf => $s->log_conf,
		name     => 'log'
	);

	container $s => as {

		service 'git_env' => (
			class        => 'Git::Cmdr::Env',
			dependencies => { logger_svc => depends_on('log/logger_svc'), }
		);

		service 'cmds' => ( class => 'Git::Cmdr::Cmds', );

		service 'pragmas' => ( class => 'Git::Cmdr::Pragmas', );

		service 'git_cmdr' => (
			class        => 'Git::Cmdr',
			dependencies => {
				logger_svc => depends_on('log/logger_svc'),
				git_env    => depends_on('git_env'),
				git_cmd    => depends_on('cmds'),
				git_pragma => depends_on('pragmas'),
			}
		);

	};

	$s->add_sub_container($log_cntnr);

	return $s;

}

no Moo;

1;
