#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin";
use Clutter;
use Modern::Perl;
use feature qw(signatures);
no warnings "experimental::signatures";

use CookbookButton;

use constant stage_color  => Clutter::Color->new( 0x33, 0x33, 0x55, 0xff );
use constant white_color  => Clutter::Color->new( 0xff, 0xff, 0xff, 0xff );
use constant yellow_color => Clutter::Color->new( 0x88, 0x88, 0x00, 0xff );

sub clicked($button) { ## no critic
	say STDERR "Clicked";

	my $current_text = $button->get_text;

	$button->set_text(
		$current_text eq 'hello'
		? 'world'
		: 'hello'
	);
}

sub main() {
	# TODO Can switch to the second line below once perl-Clutter is patched.
	# See <https://github.com/zmughal/perl-Clutter/issues/1>.
	Clutter::init;
	#die "Could not init Clutter" unless Clutter::init eq 'success';

	my $stage = Clutter::Stage->new;
	$stage->set_size(400, 400);
	$stage->set_color( stage_color );

	$stage->signal_connect( destroy => sub { Clutter::main_quit } );

	my $button = CookbookButton->new;
	$button->set_text('hello');
	$button->set_text_color( white_color );
	$button->set_background_color( yellow_color );

	$button->signal_connect( clicked => \&clicked );

	my $align_x_constraint = Clutter::AlignConstraint->new( $stage, 'x-axis', 0.5 );
	my $align_y_constraint = Clutter::AlignConstraint->new( $stage, 'y-axis', 0.5 );

	$button->add_constraint( $align_x_constraint );
	$button->add_constraint( $align_y_constraint );

	$stage->add_child($button);

	$stage->show;

	Clutter::main;
}

main;
