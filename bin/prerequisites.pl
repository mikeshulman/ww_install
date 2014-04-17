#!/usr/bin/env perl

use strict;
use warnings;

use '../lib';
use Linux::Distribution qw(distribution_name distribution_version);

sub print_and_log {
  my $msg = shift;
  print "$msg\n";
}

sub get_os {
    my $os;
    if ( $^O eq "darwin" ) {
        $os->{type} = "unix";
        $os->{name} = "darwin";
        chomp( $os->{version} = `sw_vers -productVersion` );
        chomp( $os->{arch}    = `uname -p` );
        print_and_log("Great, you're on Mac running OS X $$os{version} on $$os{arch} hardware.");
    } elsif ( $^O eq "freebsd" ) {
        $os->{type} = "unix";
        $os->{name} = "freebsd";
        chomp( $os->{version} = `uname -r` );
        chomp( $os->{arch}    = `uname -p` );
        print_and_log("I see - rocking it on FreeBSD $$os{version} on $$os{arch} hardware.");
    } elsif ( $^O eq "linux" )
    {    #Now we're going to have to look more closely to get specific distro
        $os->{type}    = "linux";
        $os->{name}    = distribution_name();
        $os->{version} = distribution_version();
        chomp( $os->{arch} = `uname -p` );
        print_and_log("Linux, yay! That's my favorite. I see you're running $$os{name} "
          . "version $$os{version} on $$os{arch} hardware. This will be easy.\n");
    } elsif ( $^O eq "MSWin32" ) {
        print_and_log("Installing WeBWorK on Windows is, afaik, currently impossible.");
        print_and_log("If you get it working, please let us know. Good luck!");
    } else {
        $os->{type}    = $^O;
        $os->{name}    = distribution_name();
        $os->{version} = distribution_version();
        chomp( $os->{arch} = `uname -p` );
        print_and_log("I see you're running $$os{name} version $$os{version} on $$os{arch} hardware. "
          . "This script mostly finds the information it needs at run time. But, there are a few "
          . "places where we have hard coded OS specific details into data structures built into the "
          . "script. We don't have anything for your OS. The script will very likely still work. Either "
          . "way, it would be very helpful if you could send a report to webwork\@maa.org. We can help you "
          . "get it working if it doesn't work, and if it does we would like to add it to the list of supported "
          . "systems.");
    }
    return $os;
}

my $prerequisites = {
  redhat =>
  {
    common => {
      mkdir => 'coreutils',
      mv => 'coreutils',
      gcc => 'gcc',
      make => 'make',
      patch => 'patch',
      system_config => 'system-config-services',
      tar => 'tar',
      gzip => 'gzip',
      unzip => 'coreutils',
      dvipng => 'dvipng',
      netpbm => 'netpbm-progs',  #provides giftopnm, ppmtopgm, pnmtops, pnmtopng, 
                          #and pgntopnm
      git => 'git',
      svn => 'subversion',

      apache2 => 'httpd',
      mysql => 'mysql',
      #mysql_server => 'mysql-server',
      #ssh_server => 'openssh-server',

      preview_latex => 'tex-preview',
      texlive => 'texlive-latex', 
      'Apache2::Request' => 'perl-libapreq2',#perl-libapreq2, mod_perl?
      'Apache2::Cookie' => 'perl-libapreq2',
      'Apache2::ServerRec' => 'mod_perl',
      'Apache2::ServerUtil' => 'mod_perl',
      'Benchmark' => 'perl',
      'Carp' => 'perl',
      'CGI' => 'perl-CGI',
      'CPAN' => 'perl-CPAN',
      'Data::Dumper' => 'perl',
      'Data::UUID' => 'uuid-perl',
      'Date::Format' => 'perl-TimeDate',
      'Date::Parse' => 'perl-TimeDate',
      'DateTime' => 'perl-DateTime',
      'DBD::mysql' => 'perl-DBD-mysql',
      'DBI' => 'perl-DBI',
      'Digest::MD5' => 'perl',
      'Email::Address' => 'perl-Email-Address',
      'Errno' => 'perl',
      'Exception::Class' => 'perl-Exception-Class',
      'File::Copy' => 'perl',
      'File::Find' => 'perl',
      'File::Find::Rule' => 'perl-File-Find-Rule',
      'File::Path' => 'perl',
      'File::Spec' => 'perl',
      'File::stat' => 'perl',
      'File::Temp' => 'perl',
      'GD' => 'perl-GD perl-GDGraph',
      'Getopt::Long' => 'perl',
      'Getopt::Std' => 'perl',
      'HTML::Entities' => 'perl-HTML-parser',
      'HTML::Scrubber' => 'perl-HTML-Scrubber',
      'HTML::Tagset' => 'perl-HTML-Tagset',
      'HTML::Template' => 'CPAN',
      'IO::File' => 'perl',
      'IPC::Cmd' => 'perl-IPC-Cmd',
      'Iterator' => 'CPAN',
      'Iterator::Util' => 'CPAN',
      'JSON' => 'perl-JSON',
      'Locale::Maketext::Lexicon' => 'perl-Locale-Maketext-Lexicon',
      'Locale::Maketext::Simple' => 'perl-Locale-Maketext-Simple',
      'Mail::Sender' => 'perl-Mail-Sender',
      'MIME::Base64' => 'perl',
      'Net::IP' => 'perl-Net-IP',
      'Net::LDAPS' => 'perl-LDAP',
      'Net::OAuth' => 'perl-Net-OAuth',
      'Net::SMTP' => 'perl',
      'Opcode' => 'perl',
      'PadWalker' => 'perl-PadWalker',
      'PHP::Serialization' => 'CPAN',
      'Pod::Usage' => 'perl',
      'Pod::WSDL' => 'CPAN',
      'Safe' => 'perl',
      'Scalar::Util' => 'perl',
      'SOAP::Lite' => 'perl-SOAP-Lite',
      'Socket' => 'perl',
      'SQL::Abstract' => 'perl-SQL-Abstract',
      'String::ShellQuote' => 'perl-String-ShellQuote',
      'Term::UI' => 'perl-Term-UI',
      'Text::CSV' => 'perl-Text-CSV',
      'Text::Wrap' => 'perl',
      'Tie::IxHash' => 'perl-Tie-IxHash',
      'Time::HiRes' => 'perl-Time-HiRes',
      'Time::Zone' => 'perl-TimeDate',
      'URI::Escape' => 'perl',
      'UUID::Tiny' => 'CPAN',
      'XML::Parser' => 'perl-XML-Parser',
      'XML::Parser::EasyTree' => 'CPAN',
      'XML::Writer' => 'perl-XML-Writer',
      'XMLRPC::Lite' => 'perl-SOAP-Lite',
    }
  },
  debian =>
  {
    common => {
      mkdir => 'coreutils',
      mv => 'coreutils',
      gcc => 'gcc',
      make => 'make',
      tar => 'tar',
      gzip => 'gzip',
      unzip => 'unzip',
      dvipng => 'dvipng',
      netpbm => 'netpbm',  #provides giftopnm, ppmtopgm, pnmtops, pnmtopng, 
                          #and pgntopnm
      git => 'git',
      svn => 'subversion',

      apache2 => 'apache2',
      mysql => 'mysql-client',
      mysql_server => 'mysql-server',
      ssh_server => 'openssh-server',

      preview_latex => 'preview-latex-style',
      texlive => 'texlive-latex-base', 
      'Apache2::Request' => 'libapache2-request-perl',
      'Apache2::Cookie' => 'libapache2-request-perl',
      'Apache2::ServerRec' => 'libapache2-mod-perl2',
      'Apache2::ServerUtil' => 'libapache2-mod-perl2',
      'Benchmark' => 'perl-modules',
      'Carp' => 'perl-base',
      'CGI' => 'perl-modules',
      'Data::Dumper' => 'perl',
      'Data::UUID' => 'libossp-uuid-perl',
      'Date::Format' => 'libtimedate-perl',
      'Date::Parse' => 'libtimedate-perl',
      'DateTime' => 'libdatetime-perl',
      'DBD::mysql' => 'libdbd-mysql-perl',
      'DBI' => 'libdbi-perl',
      'Digest::MD5' => 'perl',
      'Email::Address' => 'libemail-address-perl',
      'Errno' => 'perl-base',
      'Exception::Class' => 'libexception-class-perl',
      'ExtUtils::XSBuilder' => 'libextutils-xsbuilder-perl',
      'File::Copy' => 'perl-modules',
      'File::Find' => 'perl-modules',
      'File::Find::Rule' => 'libfile-find-rule-perl',
      'File::Path' => 'perl-modules',
      'File::Spec' => 'perl-modules',
      'File::stat' => 'perl-modules',
      'File::Temp' => 'perl-modules',
      'GD' => 'libgd-gd2-perl',
      'Getopt::Long' => 'perl-base',
      'Getopt::Std' => 'perl-modules',
      'HTML::Entities' => '',
      'HTML::Scrubber' => 'libhtml-scrubber-perl',
      'HTML::Tagset' => '',
      'HTML::Template' => 'CPAN',
      'IO::File' => '',
      'Iterator' => 'CPAN',
      'Iterator::Util' => 'CPAN',
      'JSON' => 'libjson-perl',
      'Locale::Maketext::Lexicon' => 'liblocale-maketext-lexicon-perl',
      'Locale::Maketext::Simple' => '',
      'Mail::Sender' => 'libmail-sender-perl',
      'MIME::Base64' => 'libmime-tools-perl',
      'Net::IP' => 'libnet-ip-perl',
      'Net::LDAPS' => 'libnet-ldap-perl',
      'Net::OAuth' => 'libnet-oauth-perl',
      'Net::SMTP' => 'perl-modules',
      'Opcode' => 'perl',
      'PadWalker' => 'libpadwalker-perl',
      'PHP::Serialization' => 'libphp-serialization-perl',
      'Pod::Usage' => 'perl-modules',
      'Pod::WSDL' => 'libpod-wsdl-perl',
      'Safe' => 'perl-modules',
      'Scalar::Util' => 'perl-base',
      'SOAP::Lite' => 'libsoap-lite-perl',
      'Socket' => 'perl-base',
      'SQL::Abstract' => 'libsql-abstract-perl',
      'String::ShellQuote' => 'libstring-shellquote-perl',
      'Text::CSV' => 'libtext-csv-perl',
      'Text::Wrap' => 'perl-base',
      'Tie::IxHash' => 'libtie-ixhash-perl',
      'Time::HiRes' => 'perl',
      'Time::Zone' => 'libtimedate-perl',
      'URI::Escape' => 'liburi-perl',
      'UUID::Tiny' => 'libuuid-tiny-perl',
      'XML::Parser' => 'libxml-parser-perl',
      'XML::Parser::EasyTree' => 'CPAN',
      'XML::Writer' => 'libxml-writer-perl',
      'XMLRPC::Lite' => 'libsoap-lite-perl',
    },
  },
};

$prerequisites-> {fedora} = {
  common => $prerequisites->{redhat}->{common},
};

$prerequisites->{ubuntu} = {
  common => $prerequisites->{debian}->{common},
  12.04 => {
    prefork_mpm => 'apache2-mpm-prefork',
  },
  13.04 => {
    prefork_mpm => 'apache2-mpm-prefork',
  },
};
#foreach my $os (keys $applications) {
#  print "$os => \n";
#  foreach my $ver (keys $applications->{$os}) {
#    print "\t $ver => \n"; #. $applications -> {$key}."\n";
#    foreach my $package (keys $applications->{$os}->{$ver}) {
#      print "\t\t $package => $applications->{$os}->{$ver}->{$package}\n";
#    }
#  }
#}

my $os = get_os();
print "$os->{name}\n";
print "$os->{version}\n";
my %packages = (%{$prerequisites->{$os->{name}}->{common}}, %{$prerequisites->{$os->{name}}->{$os->{version}}});
#foreach (keys %packages) {
#  print "$_ => $packages{$_}\n";
#}

my %seen = ();
foreach (values %packages) {
  $seen{$_}++ unless $_ eq 'CPAN';
}
my @uniq = keys %seen;

foreach(@uniq) {
  print "$_\n";
}

my @cpan;
foreach(keys %packages) {
  push(@cpan, $_) if $packages{$_} eq 'CPAN';
}

foreach(@cpan) {
  print "CPAN $_\n";
}