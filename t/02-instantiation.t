#!perl

use Test::More;
use Test::Exception;
use File::Path 'remove_tree';

use lib 't/lib';
use DBICDHTest;
use DBIx::Class::DeploymentHandler;
my $db = 'dbi:SQLite:db.db';
my @connection = ($db, '', '', { ignore_version => 1 });
my $sql_dir = 't/sql';

DBICDHTest::ready;

VERSION1: {
   use_ok 'DBICVersion_v1';
   my $s = DBICVersion::Schema->connect(@connection);
   ok($s, 'DBICVersion::Schema 1.0 instantiates correctly');
   my $handler = DBIx::Class::DeploymentHandler->new({
      upgrade_directory => $sql_dir,
      schema => $s,
      databases => 'SQLite',
      sqltargs => { add_drop_table => 0 },
   });

   ok($handler, 'DBIx::Class::DeploymentHandler w/1.0 instantiates correctly');

   my $version = $s->schema_version();
   $handler->prepare_install();

   dies_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
      })
   } 'schema not deployed';
   $handler->install;
   dies_ok {
     $handler->install;
   } 'cannot install twice';
   lives_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
      })
   } 'schema is deployed';
}

VERSION2: {
   use_ok 'DBICVersion_v2';
   my $s = DBICVersion::Schema->connect(@connection);
   ok($s, 'DBICVersion::Schema 2.0 instantiates correctly');
   my $handler = DBIx::Class::DeploymentHandler->new({
      upgrade_directory => $sql_dir,
      schema => $s,
      databases => 'SQLite',
   });

   ok($handler, 'DBIx::Class::DeploymentHandler w/2.0 instantiates correctly');

   $version = $s->schema_version();
   $handler->prepare_install();
   $handler->prepare_upgrade('1.0', $version);
   $handler->prepare_upgrade($version, '1.0');
   dies_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
         baz => 'frew',
      })
   } 'schema not deployed';
   dies_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
         baz => 'frew',
      })
   } 'schema not uppgrayyed';
   $handler->upgrade;
   lives_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
         baz => 'frew',
      })
   } 'schema is deployed';
}

VERSION3: {
   use_ok 'DBICVersion_v3';
   my $s = DBICVersion::Schema->connect(@connection);
   ok($s, 'DBICVersion::Schema 3.0 instantiates correctly');
   my $handler = DBIx::Class::DeploymentHandler->new({
      upgrade_directory => $sql_dir,
      schema => $s,
      databases => 'SQLite',
   });

   ok($handler, 'DBIx::Class::DeploymentHandler w/3.0 instantiates correctly');

   $version = $s->schema_version();
   $handler->prepare_install;
   $handler->prepare_upgrade( '1.0', $version );
   $handler->prepare_upgrade( '2.0', $version );
   dies_ok {
      $s->resultset('Foo')->create({
            bar => 'frew',
            baz => 'frew',
            biff => 'frew',
         })
   } 'schema not deployed';
   $handler->upgrade;
   lives_ok {
      $s->resultset('Foo')->create({
         bar => 'frew',
         baz => 'frew',
         biff => 'frew',
      })
   } 'schema is deployed';
}

done_testing;
__END__

vim: ts=2 sw=2 expandtab
