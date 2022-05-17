from aws_cdk import (
    Tag,
    aws_ec2 as ec2,
    aws_ssm as ssm,
    Stack
) 

from constructs import Construct
import config
from config import formalize
import constants

class VPCStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)


        # prj_name = self.node.try_get_context("project_name")
        # env_name = self.node.try_get_context("env")

        self.vpc = ec2.Vpc(self, 'eks_vpc',
            cidr=config.cidr_range,
            max_azs=config.azs_number,
            enable_dns_hostnames=True,
            enable_dns_support=True,
            subnet_configuration=[
                ec2.SubnetConfiguration(
                    name="Public",
                    subnet_type=ec2.SubnetType.PUBLIC,
                    cidr_mask=24
                ),
                ec2.SubnetConfiguration(
                    name="Private",
                    subnet_type=ec2.SubnetType.PRIVATE_WITH_NAT,
                    cidr_mask=24
                )
            ],
            nat_gateways=config.ngw_number,
            vpc_name=formalize(config.vpc_name),
            #### ADD TAGS FOR kubernetes.io/cluster // terraform vpc reference 
        )

        priv_subnets = [subnet.subnet_id for subnet in self.vpc.private_subnets]

        count = 1
        for ps in priv_subnets:
            ssm.StringParameter(self, 'private-subnet'+str(count),
                string_value=ps,
                parameter_name='/'+constants.ENV_NAME+'/p'+str(count)
            )
            count += 1
