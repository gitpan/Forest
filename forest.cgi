#!/usr/bin/perl

use lib '/usr/lib/forest/lib/';
use Oak::Web::Application;

my $xmldir = "/usr/lib/forest/xml";

my $app = new Oak::Web::Application
  (
   startPage => ["startPage", "$xmldir/startPage.xml"],
   actionPage => ["actionPage", "$xmldir/actionPage.xml"],
   objectInspector => ["objectInspector", "$xmldir/objectInspector.xml"],
   addComponent => ["addComponent", "$xmldir/addComponent.xml"],
   treePage => ["treePage", "$xmldir/treePage.xml"],
   endPage => ["endPage", "$xmldir/endPage.xml"],
   default => "startPage"
  );

$app->run("CGI");
