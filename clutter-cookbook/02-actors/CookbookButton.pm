package CookbookButton;

use Modern::Perl;
use Clutter;
use Glib qw(TRUE FALSE);
use Glib::Object::Subclass
	Clutter::Actor::,
	signals => {
		clicked => {}, # new signal
	},
	;
use Moo;
use feature qw(signatures);
no warnings "experimental::signatures";

has _text => ( is => 'rw' );
has _child => ( is => 'ro', default => sub { Clutter::Actor->new;  } );
has _label => (
	is => 'ro',
	default => sub {
		my $text = Clutter::Text->new();
		$text->set_property('line-alignment' => 'center');
		$text->set_property('ellipsize' => 'end');

		$text;
	}
);

sub BUILD { ## no critic
	my ($self) = @_;
	$self->set_reactive(TRUE);

	my $layout = Clutter::BinLayout->new('center', 'center');

	$self->_child->set_layout_manager( $layout );


	$self->add_child( $self->_child );

	$self->_child->add_child( $self->_label );

	my $click_action = Clutter::ClickAction->new;

	$self->add_action( $click_action );

	$click_action->signal_connect( clicked => \&cb_button_clicked );
}

sub ALLOCATE($self, $box, $flags) { ## no critic
	$self->SUPER::ALLOCATE( $box, $flags );

	my $child_box = Clutter::ActorBox->new(
		0, 0,
		$box->get_width, $box->get_height,
	);

	$self->_child->allocate( $child_box, $flags );
}

sub GET_PREFERRED_HEIGHT($self, $for_width) { ## no critic
	my ($min_height_p, $natural_height_p) =
		$self->_child->GET_PREFERRED_HEIGHT( $for_width );

	$min_height_p += 20.0;
	$natural_height_p += 20.0;

	return ($min_height_p, $natural_height_p);
}

sub GET_PREFERRED_WIDTH( $self, $for_height) { ## no critic
	my ($min_width_p, $natural_width_p) =
		$self->_child->GET_PREFERRED_WIDTH( $for_height );

	$min_width_p += 20.0;
	$natural_width_p += 20.0;

	return ($min_width_p, $natural_width_p);
}

sub PAINT($self) { ## no critic
	$self->_child->paint;
}

sub set_text($self, $text) { ## no critic
	$self->_text( $text );
	$self->_label->set_text($text);
}
sub get_text($self) { ## no critic
	$self->_text;
}
sub set_background_color($self, $color) { ## no critic
	$self->_child->set_background_color( $color );
}
sub set_text_color($self, $color) { ## no critic
	$self->_label->set_color( $color );
}

sub cb_button_clicked($action, $actor) {  ## no critic
	$actor->signal_emit('clicked');
}


1;
