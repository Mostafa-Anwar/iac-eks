#!/usr/bin/env python3
import os

from aws_cdk import (
    Stack as Stack,
    App as App,
    Environment as envir,
    Fn
)
# from deployment import EKS
import constants
import config
from stacks.vpc_stack import VPCStack
from stacks.security_stack import SecurityStack
from stacks.eks_stack import EKS
from config import (SSMStack,formalize)
from pipeline import Pipeline




app = App()

# eks = EKS(
#     app,
#     'eks-dev',
    
# )

# ssmstack = SSMStack(app, 'ssm-params', env=constants.DEV_ENV)
vpcstack = VPCStack(app,  formalize(config.vpc_name), env=constants.DEV_ENV)
securitystack = SecurityStack(app, formalize(config.security_stack_name), env=constants.DEV_ENV, vpc=vpcstack.vpc)
eksstack = EKS(app, 
    formalize(config.eks_cluster_name),
    env=constants.DEV_ENV, 
    vpc=vpcstack.vpc
    )
securitystack.add_dependency(vpcstack)
eksstack.add_dependency(securitystack)


# pipelinestack = Pipeline(app, 'eks-pipeline',
#         env=constants.ENV_DEV
#        )
# pipelinestack.add_dependency(ssmstack)


app.synth()
