# emacsconfig
The emacs configuration I am currently using. Hope this helps others. 

### Binding eshell to a shortcut in openbox.
To bind eshell to W-a, add the following lines to rc.xml, in the <keyboard> section:

```
  <keyboard>
[...]
    <keybind key="W-a">
      <action name="Execute">
        <startupnotify>
          <enabled>true</enabled>
          <name>Open Terminal</name>
        </startupnotify>
        <command>emacsclient -c -e '(eshell t)'</command>
      </action>
    </keybind>
[...]
  </keyboard>
```

### Binding multi-term to a shortcut in openbox.
To bind multi-term to W-a, add the following lines to rc.xml, in the <keyboard> section:

```
  <keyboard>
[...]
    <keybind key="W-a">
      <action name="Execute">
        <startupnotify>
          <enabled>true</enabled>
          <name>Open Terminal</name>
        </startupnotify>
        <command>emacsclient -c -e '(multi-term)'</command>
      </action>
    </keybind>
[...]
  </keyboard>
```
