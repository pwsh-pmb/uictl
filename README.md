
<!--#echo json="package.json" key="name" underline="=" -->
uictl
=====
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
PowerShell functions to interact with the Windows UI.
<!--/#echo -->



Install
-------

* You need Windows 11 or later, with PowerShell 5.1 or later.
* Clone this repo as: `%LocalAppData%\pwsh_modules\gh\pwsh-pmb\uictl\main`
  * ⚠ I learned the hard way that you cannot use your WSL2 Ubuntu guest
    to just clone onto `/mnt/c/…`: WSL will sabotage the attempt and give
    a notification on the interactive desktop that you shouldn't try to use
    git this way because of bad performance.
    So instead you may need to install Git for Windows or TortoiseGit.
  * Or just download the ZIP archive form GitHub,
    __⚠ edit the file properties ⚠__,
    in the bottom check the checkbox that you
    __⚠ trust this file from the internet ⚠__,
    and only then unpack it somewhere.
  * The `main` at the end is the branch name, for future compatibility with
    `import-pwsh-pmb-module`.
    If you prefer a worktree, you may instead clone the repo anywhere else
    (even bare) and create a worktree in the default location.
* Run `install_into_appdata.cmd`
* Done. 🎉




Usage
-----

Run `uictl.cmd` to start the REPL.




Known issues
------------

* Needs more/better tests and docs.





<!--#toc stop="scan" -->

&nbsp;


License
-------
<!--#echo json="package.json" key="license" -->
ISC
<!--/#echo -->
