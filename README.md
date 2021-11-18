# Mable Test App

This repository contains code for the following tasks:

- Create a VPC 
- Create an EKS cluster on that VPC
- Create a Dummy app which has connection to PgSql RDS (RDS is not part of this exercise) and containerised it
- Deploy the containerised app on newly created EKS cluster
- Shell script to automate above steps

# Prerequisites

To run the above shell script the following should in installed in Linux system:

- Terraform > v12
- Docker
- Kubectl

# Steps for execution
- Clone the repository - `git clone https://github.com/sobisw/test.git`
- Go into Script directory - `cd Script`
- Make sure the script has execution permission - `chmod +x deploy.sh`
- Execute the following command:
    `./deploy.sh [AWS_REGION_NAME] [dev | prod | stage]`
Valid value for `AWS_REGION_NAME` is actual AWS regions

# Scope of improvement 
- Error handling is not done for the shell script
- Input validation is not done for shell script
- In many places through out the project, some values are hard coded which can be replaced by variables
- Not every security measure and performance improvement steps have been taken

# Author
Sourav Biswas [sobisw@gmail.com]
