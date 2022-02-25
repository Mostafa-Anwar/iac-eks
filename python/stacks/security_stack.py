from aws_cdk import (
    aws_ec2 as ec2,
    aws_ssm as ssm,
    Stack
)

from constructs import Construct

class SecurityStack(Stack):
    def __init__(self, scope: Construct, construct_id: str,vpc: ec2.Vpc, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)


        prj_name = self.node.try_get_context("project_name")
        env_name = self.node.try_get_context("env")


        self.sg_eks_access = ec2.SecurityGroup(self, 'sg_eks_access',
            security_group_name='SG-eks-access',
            description='Security group for the eks-cluster',
            allow_all_outbound=True,
            vpc=vpc
        )


        self.sg_eks_fs = ec2.SecurityGroup(self, "sg_eks_fs",
            security_group_name='SG-eks-fs',
            description="Security group for the Elastic File Service",
            allow_all_outbound=True,
            vpc=vpc
        )


        self.sg_eks_db = ec2.SecurityGroup(self, "sg_eks_db",
            security_group_name="SG-eks-db",
            description="Security group for RDS",
            allow_all_outbound=True,
            vpc=vpc            
        )


        self.sg_eks_access.add_ingress_rule(ec2.Peer.any_ipv4(), ec2.Port.tcp(22), "SSH Access"),
        self.sg_eks_access.add_ingress_rule(ec2.Peer.any_ipv4(), ec2.Port.tcp(80), "HTTP Access"),
        self.sg_eks_access.add_ingress_rule(ec2.Peer.any_ipv4(), ec2.Port.tcp(443), "HTTPs Access"),

        self.sg_eks_fs.add_ingress_rule(ec2.Peer.any_ipv4(), ec2.Port.tcp(2049), "EFS Access"),
        
        self.sg_eks_db.add_ingress_rule(ec2.Peer.any_ipv4(), ec2.Port.tcp(5432), "RDS Access")


                