package DBIx::Class::DepolymentHandler::VersionResult;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table('dbix_class_deploymenthandler_versions');

__PACKAGE__->add_columns (
	installed => {
		data_type         => 'int',
		is_auto_increment => 1,
	},
	version => {
		data_type         => 'varchar',
		size              => '20'
	},
	ddl => {
		data_type         => 'text',
		is_nullable       => 1,
	},
	upgrade_sql => {
		data_type         => 'text',
		is_nullable       => 1,
	},
);

__PACKAGE__->set_primary_key('installed');
__PACKAGE__->add_unique_constraint(['version']);

1;