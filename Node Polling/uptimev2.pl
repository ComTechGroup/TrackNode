#!/usr/bin/perl

# Replaces deprecated uptime.pl script

#############################################
# Script is part of the TrackNode project.
# Licensing and other information is available at http://sourceforge.net/projects/tracknode
# Developer offers NO WARRANTY for this product
# Software is in experimental development stage - use at your own risk
#############################################

use Net::SNMP;
use strict;

my $HOST = "localhost";

unless(uptimev2()==0){
	die();
}

sub uptimev2{
	# uptimev2() prints the uptime via a local SNMP query to $HOST.  
	# as no platform-independent libraries exist for an uptime query, this is
	# the best way to perform it as of now.
	# returns 1 upon failure

	my ($s, $e) = Net::SNMP->session(
		-hostname => $HOST,
		-version => "2c",
		-community => "public",
		-timeout => "5",
		);
	if(!defined($s)){
		print $e;
		return 1;
	}
	my $table = $s->get_table(
		-baseoid => ".1.3.6.1.2.1.1.3"
		);
	foreach(keys %$table){
		my $result = $s->get_request($_);
		my %rez = %$result;
		foreach(keys %rez){
			print $rez{$_};
		}
	}
	$s->close();
	0;
}
