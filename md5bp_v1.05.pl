#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Digest::MD5 qw(md5_hex);   
use 5.010;

use constant false => 0;	#定义false,true;
use constant true  => 1;
#for md5+salt brute force

my $passwordfile;
my $plain_text;        #single password in passwordfile
my $cipher_text;
my $salt;
my $help;
my $version;
my $check_password;
my $flag=0;

##	@author by Kalagin
##	@time 2016.5.2
##	this is a program for md5+salt brute force, good luck for you !
##	useage:	perl filename.pl -p passwordfile -c cipher_text -s salt [-h|-v]

#定义参数列表
GetOptions(
	'h|help!' => \$help,
	'v|version!' => \$version,
	'p=s' => \$passwordfile,
	'c=s' => \$cipher_text,
	's=s' => \$salt,
);

#some definition for options

sub help{
say "this is a program for md5+salt brute force .good luck for you !";
say "useage:	perl filename.pl -p passwordfile -c cipher_text -s salt [-h|-v]";
say "example:   perl md5bp.pl -p pass.txt -c babc156ac796828d0d08625f86f6dc55 -s 123";
say "-h|-help	get for	some help";
say "-v|version get version";
say "-p        \$passwordfile(file path for passwords";
say "-c		   \$cipher_text (md5(md5(pass)+salt)),complex pass";
say "-s		   \$salt(the salt value for pass";
}

say "Version 1.05(just for  multiple parameters -p -c -s)" if (defined $version);
&help if(defined $help);

if(defined $passwordfile&&defined $cipher_text&&defined $salt){
	&result;
}
else{
	&help;
}

sub result{
	sub check_password{
		my $now_plain_text=$_[0];   #接收$plain_text 参数
		$check_password=md5_hex(md5_hex($now_plain_text).$salt);
		if($cipher_text ne $check_password){
			return 0;
		}
		else{
			return 1;
		}
	}

	open (FILE ,$passwordfile) or die "can't open the file $!";
	while(<FILE>){
		chomp;
		$_ =~ s/^\s+|\s+$//g;
		$plain_text=$_;
		if(&check_password($plain_text)){
			$flag=1;
			say "ok ,the password is $plain_text";
			last;
		}
	}

	if ($flag==0) {
		say "sorry , can't find the password!";
	}
	close(FILE);

}

__END__
perl md5bp.pl pass.txt 65f7c21eb4357d10aa99f9f0381febaf 170765   test
perl md5bp.pl pass.txt 38164c8c1d177f5fb83857ccd458d881 238b29   待搞定
perl md5bp.pl pass.txt babc156ac796828d0d08625f86f6dc55 123      test
