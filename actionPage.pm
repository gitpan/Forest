package actionPage;

use base qw(Oak::Web::Page);

sub on_preview_click {
	my $self = shift;
	my $filename = $::SESSION->get('filename');
	my $classname = $::SESSION->get('classname');
	eval "require $classname";
	my $obj = new $classname
	  (
	   RESTORE_TOPLEVEL => $filename,
	   IS_DESIGNING => 1
	  );
	$obj->show();
}

sub on_newComp_click {
	my $self = shift;
	$::APPLICATION->initiateTopLevel("addComponent");
	$::TL::addComponent->show;
}

sub on_objInsp_click {
	my $self = shift;
	$::APPLICATION->initiateTopLevel("objectInspector");
	$::TL::objectInspector->show;
}

sub on_tree_click {
	my $self = shift;
	$::APPLICATION->initiateTopLevel("treePage");
	$::TL::treePage->show;
}

1;
