#!/bin/bash

# 1. Defina variáveis
export AWS_REGION=us-east-1
export ACCOUNT_ID=976193236739
export OIDC_ROLE=github-repo-1341192133
export ECS_EXEC_ROLE=ecsTaskExecutionRole

export OIDC_ROLE_ARN=arn:aws:iam::$ACCOUNT_ID:role/$OIDC_ROLE
export ECS_EXEC_ROLE_ARN=arn:aws:iam::$ACCOUNT_ID:role/$ECS_EXEC_ROLE


# Confirme a conta:
aws sts get-caller-identity

# 2. Crie a trust policy da role ECS
cat > ecsTaskExecutionRoleTrustPolicy.json <<'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# 3. Crie a role de execução
aws iam create-role \
  --role-name "$ECS_EXEC_ROLE" \
  --assume-role-policy-document file://ecsTaskExecutionRoleTrustPolicy.json

# Anexe a política padrão de execução ECS:
aws iam attach-role-policy \
  --role-name "$ECS_EXEC_ROLE" \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy

# 4. Conceda iam:PassRole à role usada pelo GitHub Actions  
cat > pass-ecs-role-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "$ECS_EXEC_ROLE_ARN",
      "Condition": {
        "StringEquals": {
          "iam:PassedToService": "ecs-tasks.amazonaws.com"
        }
      }
    }
  ]
}
EOF

aws iam put-role-policy \
  --role-name "$OIDC_ROLE" \
  --policy-name PassEcsTaskExecutionRole \
  --policy-document file://pass-ecs-role-policy.json


# 5. Verifique as configurações

## Trust policy da role ECS:  
aws iam get-role \
  --role-name "$ECS_EXEC_ROLE" \
  --query 'Role.AssumeRolePolicyDocument' \
  --output json

## Políticas anexadas:
aws iam list-attached-role-policies \
  --role-name "$ECS_EXEC_ROLE"

## Política PassRole:
aws iam get-role-policy \
  --role-name "$OIDC_ROLE" \
  --policy-name PassEcsTaskExecutionRole

aws iam simulate-principal-policy \
    --policy-source-arn ${OIDC_ROLE_ARN} \
    --action-names iam:PassRole \
    --resource-arns ${ECS_EXEC_ROLE_ARN} \
    --context-entries ContextKeyName=iam:PassedToService,ContextKeyType=string,ContextKeyValues=ecs-tasks.amazonaws.com
