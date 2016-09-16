## Ansible Notes

Ansible is an opensource configuration management and orchestration utility.
It can automate and standardize the configuration of remote hosts and virtual
machines.

Instead of writing custom, individualized scripts, system administrators create
high level *plays* in Ansible.  A play performs a series of tasks on the host
or group of hosts, specified in the play.

Ansible's architecture is agentless.  Work is pushed to remote hosts when Ansible
executes. Modules are the programs that perform the actual work of the tasks
of a play.  Ansible comes with hundreds of core modules that perform useful
system administrative work.

### Ansible concepts and architecture

There are two types of machines in the Ansible architecture: the *control node*
and the *managed node*.

The Ansible software is installed in the *control node* and all of its
components are maintained on it.  The managed hosts are listted in the
*host inventory*, a text file on the control node that includes a list of
managed host names or IP addresses.

System administrators log into the control node and launch Ansible, providing it with
a *playbook* and a target host to manage.  You can specify a group of hosts,
or a wildcard, on the command line.  Ansible uses SSH as a network transport
to communicate with the managed hosts.

Ansible Users can also write their own *custom modules* but the
core ones that come with Ansible can perform most system adminitrator tasks.

## Role and requirements for the control node

System administrators initiate all Ansible operations from the control node. All
Ansible configuration files are maintained in the control node.

## Role and requirements for the managed hosts

A *managed host* is a system that Ansible logs into, install modules, and executes
remote commands to perform configuration tasks.

Ansible uses SSH to communicate with managed hosts, so SSH must be installed
and configured to allow incoming connections.

** Questions **

1. C
2. A
3. E
4. D
5. D

### Ansible Orchestration Methods

Ansible is commonly used to finish provisioning application servers.

1. Configure software repositories
2. Install the application
3. Tune configuration files.
4. Open required service ports in the firewall.
5. Start relevant services.
6. Test the application and confirm it is functioning.

**Serial** is a keyword that can be used to limit the number of hosts that the playbook
runs on at once.

**Fork** is a directive that controls the number of parallel processes to spawn/

### Ansible Connection Plugins

Connection plugins allow Ansible to communicate with managed hosts and cloud providers.
The prefered connection plugin for newer versions of Ansible is the native SSH
plugin.  It is the connection method that Ansible uses when OpenSSH on the control node
supports the **ControlPersist** option.

Another connection plugin used for Linux applications is the **local** connection
plugin.  It can be used to manage the Ansible control node locally without having
to use SSH.  This connection method is typically ised when writing Ansible playbooks
that interface with Cloud services or some other API. It can also be used when
Ansible is invoked locally by a cron job.

Quiz
1. D
2. D
3. B


# Describing Ansible Inventory

A host inventory defines which hosts Ansible manages.  Hosts may belong to groups which are
typically used to identify the hosts' role in the datacenter.  A host can be a member of
more than one group.

There are two ways in which host inventories can be defined. A static host inventory
may be defined by a text file, or a dynamic host inventory may be generated
from outside providers.

== Static host inventory
An Ansible static host inventory is defined in an INI-like text file, in which each section defines
one group of hosts (a **host group**). Each section starts with a host group
name enclosed in square brackets([]).

Host entries can also define how Ansible communicates with the managed host, including transport
and user account information.

Example:
[webservers]
localhost ansible_connection=local ansible_user=lesterclaudio

The default location of the hosts inventory file is in /etc/ansible/hosts.  You can use the --inventory or -i
to provide a different path.

### Defining host inventory groups of groups

Ansible inventory files can include groups of host groups. This is accomplished with the :children
suffix.  Here's an example:

[iad]
one.iad.redhat.com
two.iad.redhat.com

[rdu]
one.rdu.redhat.com
two.rdu.redhat.com

[redhat:children]
iad
rdu

### Simplifying host inventories with ranges

Ansible hsot inventories can be simplified by specifying ranges in the host names or IP
addresses. Numeric ranges can be specified as well as alphanumeric ranges
Examples:

* 192.168.[0:1].[0:255]
* server[01:20].example.com

### Defining variables in the host inventory
Values for variables used by playbooks can be specified in host inventory files.
These variables would apply to specific hosts or host groups only.

## Dynamic host inventory
Ansible host inventory can also be dynamically generated. Ansible has scripts that
handle dynamic host, group, and variable information from EC2, Cobbler,
Rackspace, and OpenStack.

QUIZ
1. C
2. D
3. B
4. E

Quiz: Introducing Ansible

1. C
2. B
3. C

## Installing Ansible

### Ansible Pre Requisites

#### Control node
* Python 2 version 2.6 or later
$ yum list installed python

#### Managed node
* Python 2 version 2.4 or higher
* python-simplejson if the version of python is earlier than 2.5

## Listing Hosts and Patterns
** List hosts **
$ ansible localhost -i /etc/ansible/hosts --list-hosts

** All inventory items **
$ ansible all -i inventory --list-hosts

** Wildcard for host inventory **
$ ansible '*' -i inventory --list-hosts

$ ansible '*.example.com' -i inventory --list-hosts

$ ansible '192.168.0.*' -i inventory --list-hosts

** Advance Host Patterns **
 The ':' character is to perform inclusion in the host pattern

$ ansible lab:datacenter -i inventory --list-hosts

The '&' character is to perform exclusion in the host pattern.

$ ansible lab:&datacenter -i inventory --list-hosts

The '!' along with the ':' is to exclude host pattern

$ ansible lab:!node1.example.com -i inventory --list-hosts


## Managing Ansible Configuration Files

### Configuring Ansible

1. Ansible uses the ansible.cfg file in the current directory if it exists
2. Ansible uses the .ansible.cfg if the ansible.cfg does not exist in the current directory.
3. Ansible uses the /etc/ansible/ansible.cfg if all the above files do not exist.

You can use the $ANSIBLE_CONFIG variable to use a different configuration file.

### Ansible Configuration File

There are several sections that exist in the configuration files.
[defaults]
[privilege_escalation]
[paramiko_connection]
[ssh_connection]
[accelerate]
[selinux]
[galaxy]

Most of the settings are grouped under the *[defaults]* section.
The *[privilege_escalation]* section contains settings for defining how operations that require
escalation privileges will be executed.
The *[paramiko_connection]*, *[ssh_connection]* and *[accelerate]* section contains
settings for optimizing connections to managed hosts.
The *[selinux]* section contains settings for defining how SELinux interactions
will be configured.
A section *[galaxy]* is also available for defining parameters related to
Ansible Galaxy.

### Ansible Settings
* inventory - Location of Ansible config file.
* remote user - Remote user account used to establish connections
* become - Enables/Disables privilege escalation.
* become_method - Defines escalation method on managed hosts.
* become_user - The user account to escalate privileges to.
* become_ask_pass - Whether to prompt for a password
* module_name - Default module e.g. command


### Implementing Modules

Modules are programs that Ansible uses to perform operations on managed hostss.
Modules can be executed from the **ansible** command line or used in playbooks.

There are three types of modules:
* *Core modules* are included in Ansible and are written and maintained
by the Ansible development team.
* *Extras modules* are currently included with Ansible but may be promoted to
*Core* modules in the future.
* *Custom modules* are modules developed by end users and not shipped by
Ansible.

$ANSIBLE_LIBRARY - Environment variable that defines where the Ansible modules
live.
*library* parameter in the ansible.cfg will define this directory.

Ansible will also look in the ./library directory relative to the location of
the playbook being used.

For RHEL7 Ansible module can be found in the
/usr/lib/python2.7/site-packages/ansible/modules directory.

Documentation for ansible:

        $ ansible-doc -l

Documentation for yum:

        $ ansible-doc yum

Snippet documentation for yum:

        $ ansible-doc -s yum

### Implementing Ansible Playbooks

* Playbooks are files which describe the desired configurations or procedural steps
to implement on managed hosts.

#### Sample Playbook with Blocks


    ---
    - name: my test
      hosts: localhost
      connection: local
      tasks:
      - block:
        - name: Task One
          command: ls -la
      - block:
        - name: Task Two
          command: cat /etc/motd

    - name: Another test
      hosts: localhost
      connection: local
      tasks:
      - name: First Another Test Task
        uri:
           url: http://google.com
           status_code: 200


### Managing Variables

Ansible supports variables that can be used to store values that can be reused
throughout the files in an entire Ansible project.

Variables provide a convenient way to manage dynamic values for a given environment
in your Ansible project.

Example:
* Users to create
* Packages to install
* Services to restart
* Files to remove
* Archives to retrieve from the Internet

#### Naming Variables

Variables have names which consist of a string that must start with a letter
and can only contain letters, numbers and underscores.

#### Defining Variables

Variables can be defined in a variety of places.

* *Global scope*: Variables set from the command line or Ansible configuration
* *Play scope*: Variables set in the play and related structures
* *Host scope*: Variables set on host groups and individual hosts by the inventpry,
fact gathering, or registered tasks.

#### Variables in Playbooks

Playbook variables can be defined in multiple ways:

* At the beginning of a playbook:

    - hosts: all
      vars:
        user: joe
        home: /home/joe

* It is also possible to define playbook variables in external files.

       - hosts: all
      vars_files:
        - vars/users.yml

* The users.yml file would look like this:

      ---
      user: joe
      home: /home/joe

#### Using Variables in playbooks

Once the variables are declared administrators can use the variables in tasks.

Example:

    vars:
        user: joe

    tasks:
      - name: Creates the user {{ user }}
        user:
          name: "{{ user }}"

#### Host Variables and Group Variables

Inventory variables that apply directly to hosts fall into two broad categories:
* Host variables - Apply to specific hosts.
* Group variables - Apply to all hosts

Host variables take precedence over Group variables.

Example Host Variable:

    [servers]
    demo.example.com ansible_user=joe

Example Group Variable:
    [servers]
    demo.example.com

    [servers:vars]
    user=joe

Example of a Group variables defined to a group of servers

    [servers1]
    demo1.example.com
    demo2.example.com

    [servers2]
    demo3.example.com
    demo4.example.com

    [servers:children]
    servers1
    servers2

    [servers:vars]
    user=joe

Although we can go with the above approach it can get a bit messy.  The alternative is to use the
*group_vars* and *host_vars* directories to organize variables.

#### Using group_vars and host_vars directories

The preferred approach is to create two directories in the same working directory as the in ventory
file. These directories contain files defining group and host variables respectively.

Example:
        $ cat ~/project/inventory

        [servers1]
        demo1.example.com
        demo2.example.com

        [servers2]
        demo3.example.com
        demo4.example.com

        [servers:children]
        servers1
        servers2

* If a value needs to be defined for all servers in both servers1 and servers2
a group variable can be set for servers:

        $ cat ~/project/group_vars/servers
        package: httpd

* If the value differes from each server group a group variable can be set
for each server group:

        $ cat ~/project/group_vars/servers1
        package: httpd

        $ cat ~/project/group_vars/servers2
        package: apache

  * If the value to be defined is different varies from host to host we can do the
  following:

        $ cat ~/project/group_vars/demo1.example.com
        package: httpd

        $ cat ~/project/group_vars/demo2.example.com
        package: apache


#### Overriding variables from the command line

Inventory variables are overriden by variables set in the playbook but
both set of variables can be overriden through arguments passed to the **ansible** or
**ansible-playbook** commands on the command line.

Example:

        $ ansible-playbook mybook.yml -e "package=httpd"

#### Variables and arrays

Instead of assigning related data items to variables we can use arrays.

Example:

        users:
          lclaudio:
            first_name: Lester
            last_name:  Claudio
            home_dir: /home/lclaudio
          acook:
            first_name: Andrew
            last_name: Cook
            home_dir: /home/acook

Users can be accessed using the following variables:

        # Returns 'Lester'
        users.lclaudio.first_name

You can also use the following alternative:

         # Returns 'Lester'
         users['lclaudio']['first_name']


#### Registered Variables

Administrators can capture the output of a commandby using the **register** statement.
The output is saved into a variable that could be used later for either debugging
purposes or used for something else.

Example:
       ---
       - name: Installa a package
         hosts: all
         tasks:
           - name: Install httpd
             yum:
               name: httpd
               state: installed
             register: install_result


#### Managing Facts

Ansible facts are varisables that are automatically discovered by Ansible
from a managed host. Facts are pulled by the setup module and contain useful information
stored into variables that administrators can reuse.

Example:
* A server can be restarted depending on the current kernel version.
* The MySQL configuration file can be customized depending on the available memory.
* Users can be create depending on the host name.

Ansible Facts:

| Fact          | Variable                                     |
| --------------|:--------------------------------------------:|
| Hostname      | {{ ansible_hostname }}                       |
| IPv4 Address  | {{ ansible_default_ipv4.address }}           |
| Partition Sz  | {{ ansible_devices.vda.partition.vda.size }} |
| DNS servers   | {{ ansible_dns.nameservers }}                |
| kernel ver    | {{ ansible_kernel }}                         |


Facts filters

You can limit the results of facts by using the *filter* keyword.
Example:

        $ ansible localhost -m setup -a "filter=ansible_eth0"

  You can disable the fact gathering by setting the *gather_facts: no* variable.

  Custom Facts can be created:

  * Defining a particular value for a system based on a custom script.
  * Defining a value based on a program execution.

  Custom facts are found by Ansible in the /etc/ansible/facts.d directory.
  All files must have a .fact extension. You can use JSON or INI style formatting.

  #### Managing Inclusions

  You can use separate files to include tasks and list of variables.

  Example:
          ---
          hosts: all
          tasks:
            - name: Outside task
              include: tasks/db_server.yml


  You can also use it to include variables.

  Example:
          ---
          tasks:
            - name: Include vars from file
              include_vars: vars/variables.yml
