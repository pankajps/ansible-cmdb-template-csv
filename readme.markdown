# ansible-cmdb-template-csv

Extended csv template for ansible-cmdb

## Dependencies

* [`ansible`](http://docs.ansible.com/ansible/intro_installation.html)
* [`ansible-cmdb`](https://github.com/fboender/ansible-cmdb)

## Usage

````
mkdir out
ansible -m setup -i production --tree out/ all
ansible-cmdb -t csv-extended -i production out/ > out/overview-ext.csv
cat out/overview-ext.csv
````
