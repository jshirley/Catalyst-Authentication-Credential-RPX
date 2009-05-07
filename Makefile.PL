use inc::Module::Install;

name     'Catalyst-Authentication-Credential-RPX';
all_from 'lib/Catalyst/Authentication/Credential/RPX.pm';
author   'Scott McWhirter <konobi@cpan.org>';

build_requires 'Test::More';

requires 'Net::API::RPX';

auto_install;

WriteAll;

