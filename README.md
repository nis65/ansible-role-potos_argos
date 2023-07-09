
# Ansible Role - potos\_argos

This role works for me, but does not satisfy the potos acceptance rules yet:

* the automated checks are currently failing
* meta is not up to date

Argos is IMHO the simplest way of extending your gnome top row with
small utilities (a.k.a. gnome shell extensions). An argos script creates
a few lines on its standard output and argos will interpret that output
to create menu entries.

This role installs [argos](https://github.com/p-e-w/argos) from github
to `/usr/local/share/gnome-shell/extensions`.

To enable argos, the user has to call `toggle_argos` once from the
command line.

The following example scripts are distributed to `/usr/local/src/potos_argos`:

* `mgmt`: suspend and hibernate that works (needs potos_hibernate rule)
* `multiroom.r.1s+.sh`: control `mpd` and `snapserver`
* `set-res.r.+.sh`: change resolution on wayland (together with `gnome-randr` copied from [here](https://github.com/maxwellainatchi/gnome-randr-rust))
* `smb_mount.r.+.sh`: manage Samba-Shares behind VPN connections (together with `mount_smb_sudo` from my [specs repo](https://github.com/nis65/ansible-specs-potos-mlc/blob/main/files/potos_files/usr/local/bin/mount_smb_sudo)

To use such a script, just copy it to `~/.config/argos` and make it executable. As argos
*is inspired by, and fully compatible with, the BitBar app for macOS*, you can use
any BitBar app that runs on linux.

## Example Playbook

As this role is tested via Molecule one can use [that
playbook](./molecule/default/converge.yml) as a starting point:

```yaml
---

- name: Converge
  hosts: all
  gather_facts: yes
  tasks:
    - name: run role
      ansible.builtin.include_role:
        name: 'ansible-role-potos_template'
```

## Role Variables

The default variables would be defined in [defaults/main.yml](./defaults/main.yml),
but there currently no variables for this role.

## Requirements

N/A

## License

See [LICENSE](./LICENSE)

## Author Information

[Project Potos](https://github.com/projectpotos)

