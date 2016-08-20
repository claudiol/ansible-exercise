# Command line instructions
## Git global setup

git config --global user.name "Lester Claudio"
git config --global user.email "claudiol@redhat.com"

## Create a new repository

git clone ssh://git@gitlab.consulting.redhat.com:2222/claudiol/Ansible-407.git
cd Ansible-407
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master

## Existing folder or Git repository

cd existing_folder
git init
git remote add origin ssh://git@gitlab.consulting.redhat.com:2222/claudiol/Ansible-407.git
git add .
git commit
git push -u origin master

