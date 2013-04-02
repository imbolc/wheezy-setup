Setup Debian Wheezy server
==========================

Run from root
-------------
    # cd; wget --no-check-certificate https://raw.github.com/imbolc/wheezy-setup/master/root-install.sh
    # bash root-install.sh

Create user
-----------
    # adduser <username>
    
Remove user sudo password. Add to **/etc/sudoers**

    user ALL=NOPASSWD: ALL


Run from user
-------------
    # su <user>
    $ cd; wget --no-check-certificate https://raw.github.com/imbolc/wheezy-setup/master/user-install.sh
    $ bash user-install.sh


Setup ssh pubkey auth
---------------------
Copy pubkey from local mashine:

    local@mashine$ ssh-copy-id <user@sever_ip>


Edit **/etc/ssh/sshd_config**:

    # disable password auth
    PasswordAuthentication no
    PermitEmptyPasswords no

    # disable root login
    PermitRootLogin no

    # ssh access allowed user list
    AllowUsers <user>

Restart ssh daemon: 

    /etc/init.d/ssh restart

