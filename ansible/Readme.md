# Ansible

Import it using

```ansible
#ansible all -m ping
#ansible-playbook install_packages/main.yml
#ansible-playbook -i ansible/hosts -u elemento-root --become-password-file ansible/psw ansible/main.yml
- name: gluster
  hosts: node
  become: true
  become_user: root
  become_method: sudo
  tasks: 
    - name: Install gluster
      include_tasks: gluster.yml
```
