# Getting Started

Provided TF & Ansible code is used to deploy MediaWiki Application on AWS cloud provider. TF Config will create AWS resources including VPC (public/private subnets), webserver and database. 

## MediaWiki pre-requesties

  Pre-Requesties-
  1. Aws cli configured
  2. Ansible version 2.2 or above
  3. Terraform Version 12 supported

## Deployment commands
```
Clone git repo in your linux host and goto repo directory & Run below command to execute deployment. 

#sh mediawiki.sh
  
```

** After installation it will genrate mediawiki config files in your system. 

## MediaWiki Setup
```

After successfully completion of installation you will get path of mediawiki config file on your terminal. It contians your apache_ip & mysql_ip and mysql user login details. 

It helps you to complete your MediaWiki inital setup. Once done you have update your LocalSetting.php in webserver. To do this run below command from same M-WIKI directory.

ansible-playbook -i ansible/hosts ansible/local_set.yml --vault-password-file=/tmp/pswrd"

```