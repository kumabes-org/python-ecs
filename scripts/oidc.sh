#!/bin/bash

## Create
aws iam create-role --role-name github-repo-1341192133 --assume-role-policy-document file://data.json
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --role-name github-repo-1341192133

## Rollback
aws iam detach-role-policy --role-name github-repo-1341192133 --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam delete-role --role-name github-repo-1341192133
