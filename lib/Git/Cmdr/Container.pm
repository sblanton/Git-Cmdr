package Git::Cmdr::Container;

use Moo;
use Bread::Board;

extends 'Bread::Board::Container';

use App::Services::Logger::Container;
use Git::Cmdr::Cmd;

has name => (
	is      => 'ro',
	default => sub { 'Git_Cmdr' },
);

has log_conf => (
	is      => 'rw',
	default => sub {
		\qq/ 
log4perl.rootLogger=INFO, main
log4perl.appender.main=Log::Log4perl::Appender::Screen
log4perl.appender.main.layout   = Log::Log4perl::Layout::SimpleLayout
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

		service 'git_cmdr' => (
			class        => 'Git::Cmdr::Cmd',
			dependencies => {
				logger_svc => depends_on('log/logger_svc'),
				git_env    => depends_on('git_env'),
			}
		);

	};

	$s->add_sub_container($log_cntnr);

	return $s;

}

no Moo;

1;
