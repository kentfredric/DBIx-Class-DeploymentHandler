package DBIx::Class::DeploymentHandler::VersionStorage::Deprecated::VersionResult;

use strict;
use warnings;

use parent 'DBIx::Class::Core';

__PACKAGE__->table('dbix_class_deploymenthandler_versions');

__PACKAGE__->add_columns (
   version => {
      data_type         => 'VARCHAR',
      is_nullable       => 0,
      size              => '10'
   },
   installed => {
      data_type         => 'VARCHAR',
      is_nullable       => 0,
      size              => '20'
   },
);

__PACKAGE__->set_primary_key('version');

__PACKAGE__->resultset_class('DBIx::Class::DeploymentHandler::VersionStorage::Deprecated::VersionResultSet');

1;
