# ansible-playbook --version
# ansible-playbook [core 2.16.2]
#   config file = /etc/ansible/ansible.cfg
#   configured module search path = ['/home/patrick/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
#   ansible python module location = /usr/lib/python3.12/site-packages/ansible
#   ansible collection location = /home/patrick/.ansible/collections:/usr/share/ansible/collections
#   executable location = /usr/bin/ansible-playbook
#   python version = 3.12.1 (main, Dec 18 2023, 00:00:00) [GCC 13.2.1 20231205 (Red Hat 13.2.1-6)] (/usr/bin/python3)
#   jinja version = 3.1.3
#   libyaml = True

# Run this script in ./ansible/ directory
# needed for ansible.cfg setting to output yml to work.
rm ansible.cfg
cp ansible-fedora.cfg ansible.cfg
ansible-galaxy collection install community.general
