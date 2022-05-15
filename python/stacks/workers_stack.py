from aws_cdk import (
    Fn,
    ICfnConditionExpression,
    aws_eks as eks,
    aws_ec2 as ec2,
    aws_iam as iam,
    CfnCondition as CfnCondition,
    Stack
)
from constructs import Construct

import config



class WORKERS(Stack):
    def __init__(self, scope: Construct, construct_id: str, vpc: ec2.Vpc, k8s ,  **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)      

    

        fargate1 = eks.FargateProfile(self, "fargate-group-1",
                    cluster=k8s.cluster,
                    selectors=[eks.Selector(namespace="default")],
                    fargate_profile_name="fargate-1",
                    vpc=vpc,
                    subnet_selection=ec2.SubnetType.PRIVATE_WITH_NAT
        )
     
        

        fargate2 = eks.FargateProfile(self, "fargate-group-2",
                    cluster=k8s.cluster,
                    selectors=[eks.Selector(namespace="fargate")],
                    fargate_profile_name="fargate-2",
                    vpc=vpc,
                    subnet_selection=ec2.SubnetType.PRIVATE_WITH_NAT,
        )


        fargate2.node.add_dependency(fargate1)