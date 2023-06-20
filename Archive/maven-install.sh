#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install java-openjdk11 -y
java --version
sudo wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven

## Configure MAVEN_HOME and PATH Environment Variables
rm .bash_profile
wget https://raw.githubusercontent.com/awanmbandi/realworld-cicd-pipeline-project/jenkins-master-client-config/.bash_profile
source .bash_profile
mvn -v

## Provision Jenkins Master User
sudo su
useradd jenkinsmaster 
echo jenkinsmaster | passwd jenkinsmaster --stdin ## Amazon Linux

## Enable Password Authentication and Authorization
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd
echo "jenkinsmaster   ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
chown -R jenkinsmaster:jenkinsmaster /opt

## Install Git SCM
yum install git -y

## Download the settings.xml file into /home/USER/.m2 to provide Authorization to Nexus
mkdir /home/jenkinsmaster/.m2
wget https://raw.githubusercontent.com/awanmbandi/realworld-cicd-pipeline-project/maven-sonarqube-nexus-jenkins/settings.xml -P /home/jenkinsmaster/.m2/
chown jenkinsmaster:jenkinsmaster /home/jenkinsmaster/.m2/
chown jenkinsmaster:jenkinsmaster /home/jenkinsmaster/.m2/settings.xml