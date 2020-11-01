package bootbasetest;
use testapi;
use base 'opensusebasetest';
use strict;
use warnings;

sub post_fail_hook {
    my ($self) = @_;
    # check for text login to check if X has failed
    if (check_screen('generic-login')) {
        record_info 'Seems that the display manager failed';
    }

    # crosscheck for text login on tty1
    select_console 'root-console';
    # collect and upload some stuff
    $self->export_logs();
    # call parent's post fail hook
    $self->SUPER::post_fail_hook;

}

1;
