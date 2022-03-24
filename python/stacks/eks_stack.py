from aws_cdk import (
    aws_eks as eks,
    aws_ec2 as ec2,
    aws_iam as iam,
    Stack
)
from constructs import Construct

class EKS(Stack):
    def __init__(self, scope: Construct, construct_id: str, vpc: ec2.Vpc, sg: ec2.SecurityGroup, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        master_role = iam.Role(self, "eks-master-role",
                    assumed_by=iam.ServicePrincipal("eks.amazonaws.com"),
                    role_name="python-eks-prod-cluster-role",
                    managed_policies=[
                        iam.ManagedPolicy.from_aws_managed_policy_name("AmazonEKSClusterPolicy"),
                        iam.ManagedPolicy.from_aws_managed_policy_name("AmazonEKSVPCResourceController")
                        ], 
        )

        node_role = iam.Role(self, "eks-nodegp-role",
                    assumed_by=iam.ServicePrincipal("ec2.amazonaws.com"),
                    role_name="python-eks-prod-cluster-role",
                    managed_policies=[
                        iam.ManagedPolicy.from_aws_managed_policy_name("AmazonEKSWorkerNodePolicy"),
                        iam.ManagedPolicy.from_aws_managed_policy_name("AmazonEKS_CNI_Policy"),
                        iam.ManagedPolicy.from_aws_managed_policy_name("AmazonEC2ContainerRegistryReadOnly")
                        ], 
        )



        cluster =  eks.Cluster(self, "EKS", 
                    cluster_name="prod-eks-cluster",
                    version=eks.KubernetesVersion.V1_21,
                    vpc=vpc,
                    vpc_subnets=[ec2.SubnetSelection(subnet_type=ec2.SubnetType.PUBLIC)],
                    security_group=sg,
                    default_capacity=0,
                    role=master_role
                    )

        ### Todo -- Fix autoscaling part
        # asg = cluster.add_auto_scaling_group_capacity(self, "eks-asg",
        #                                         auto_scaling_group_name="eks-asg",
        #                                         instance_type=[ec2.InstanceType('t3.medium')],
        #                                         machine_image_type="AMAZON_LINUX_2",
        #                                         key_name="eks-ec2",
        #                                         min_capacity=2,
        #                                         max_capacity=3,
        #                                         vpc_subnets=[ec2.SubnetSelection(subnet_type=ec2.SubnetType.PUBLIC)]
        #                                         )
                

        nodegp = eks.Nodegroup(self, "py-ng",
                    cluster=cluster,
                    nodegroup_name="worker-ng",
                    remote_access=eks.NodegroupRemoteAccess(
                                  ssh_key_name="eks-ec2"),
                    node_role=node_role,
                    capacity_type=eks.CapacityType.ON_DEMAND,
                    desired_size=2,
                    disk_size=35,
                    instance_types=[ec2.InstanceType('t3.medium')],
                    subnets=ec2.SubnetType.PUBLIC
                )


