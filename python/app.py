#!/usr/bin/env python3
import os

from aws_cdk import Stack, App, Environment
# from deployment import EKS
from stacks.vpc_stack import VPCStack
from stacks.security_stack import SecurityStack

env_dev  = Environment(account='585905982547', region='us-east-1')
env_test = Environment(account='585905982547', region='us-east-2')

app = App()

# eks = EKS(
#     app,
#     'eks-dev',
    
# )

vpcstack = VPCStack(app, 'eks-vpc', env=env_dev)
securitystack = SecurityStack(app, 'eks-security', env=env_dev, vpc=vpcstack.vpc)


app.synth()
