package endPage;

use base qw(Oak::Web::Page);

sub on_show {
	my $self = shift;
	my $file = $::SESSION->get('filename');
	open(FILE, $file);
	my $src;
	while (<FILE>) {
		$src .= $_;
	}
	$self->textarea_file->set(text => $src);
	$self->set("expire_cookies" => 1);
	unlink $file;
	return 1;
}

1;
