win-vagrant-meteor
------------------

Run Meteor.js windows using Vagrant

## How run?

Clone this and run VM

```shell
git clone https://github.com/osv/win-vagrant-meteor.git
cd win-vagrant-meteor
vagrant up
vagrant ssh
```

`shared` folder used for sharing files to VM and host. Copy here your meteor project.

```shell
#let clone your project
git clone YOUR-PROJECT shared/myApp
```

And generate start script:

```shell
cd ~/shared
new-project.bash myApp/
cd myApp/
./start.sh
```

If you interrupt script by control-C just run `meteor`

## What happens?

Script `new-project.bash` create `.<APPNAME>/start.sh` and `./mountall.sh`.

`start.sh` mount binded directory (`.meteor/local`) and run meteor

`mountall.sh` contains all `mount --bind` commands. You may run it if have lot of projects and dont run `./start.sh`
