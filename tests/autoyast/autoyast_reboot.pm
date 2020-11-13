# Copyright (C) 2015-2020 SUSE LLC
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, see <http://www.gnu.org/licenses/>.

# Summary: Reboot for autoyast scenarios
# - Call power_action reboot, with options "keepconsole => 1" and "textmode =>
# 1"
# Maintainer: Pavel Sladek <psladek@suse.cz>

use strict;
use warnings;
use base 'basetest';
use testapi;
use power_action_utils 'power_action';
use version_utils 'is_sle';
use utils qw(zypper_call);

sub run {
    # We are already in console, so reboot from it and do not switch to x11 or root console
    # Note, on s390x with SLE15 VNC is not running even if enabled in the profile
    select_console 'root-console';
    assert_script_run 'zypper ar --no-gpgcheck http://download.suse.de/ibs/home:/fbui:/branches:/SUSE:/SLE-15:/Update/SLE_15_SP2/ fbui';
    assert_script_run 'zypper -n dup --allow-vendor-change --from fbui';
    assert_script_run 'sed -i -e "s,#Enable=true,Enable=true," /etc/gdm/custom.conf';
    script_run 'cat /etc/gdm/custom.conf';
    save_screenshot;
    script_run 'echo Environment=SYSTEMD_LOG_LEVEL=debug >> /usr/lib/systemd/system/systemd-logind.service';
    power_action('reboot', textmode => 1, keepconsole => 1);
}

1;

