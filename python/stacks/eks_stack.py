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




class EKS(Stack):
    def __init__(self, scope: Construct, construct_id: str, vpc: ec2.Vpc, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        master_role = iam.Role(self, "eks-master-role",
                    assumed_by=iam.ServicePrincipal("eks.amazonaws.com"),
                    role_name=config.eks_master_role_name,
                    managed_policies=[
                        iam.ManagedPolicy.from_aws_managed_policy_name("AmazonEKSClusterPolicy"),
                        iam.ManagedPolicy.from_aws_managed_policy_name("AmazonEKSVPCResourceController")
                        ], 
        )

        node_role = iam.Role(self, "eks-nodegp-role",
                    assumed_by=iam.ServicePrincipal("ec2.amazonaws.com"),
                    role_name=config.eks_node_role_name,
                    managed_policies=[
                        iam.ManagedPolicy.from_aws_managed_policy_name("AmazonEKSWorkerNodePolicy"),
                        iam.ManagedPolicy.from_aws_managed_policy_name("AmazonEKS_CNI_Policy"),
                        iam.ManagedPolicy.from_aws_managed_policy_name("AmazonEC2ContainerRegistryReadOnly")
                        ], 
        )



        cluster =  eks.Cluster(self, "eks-cluster", 
                    cluster_name=config.eks_cluster_name,
                    version=eks.KubernetesVersion.V1_21,
                    vpc=vpc,
                    # vpc_subnets=[ec2.SubnetSelection(subnet_type=ec2.SubnetType.PUBLIC)],
                    # security_group=sg,
                    default_capacity=0,
                    place_cluster_handler_in_vpc=True,
                    role=master_role
        )


                

        nodegp = eks.Nodegroup(self, "nodegroup",
                    cluster=cluster,
                    nodegroup_name=config.eks_nodegroup_name,
                    remote_access=eks.NodegroupRemoteAccess(
                                  ssh_key_name=config.eks_ssh_key_name),
                    node_role=node_role,
                    capacity_type=eks.CapacityType.ON_DEMAND,
                    desired_size=1,   
                    max_size=2, 
                    min_size=1,
                    disk_size=35,
                    instance_types=[ec2.InstanceType(config.eks_instancetype)],
                    subnets=ec2.SubnetType.PRIVATE_WITH_NAT,
                    tags={
                      "Name": config.eks_nodegroup_name
                    },
                    # taints=[eks.TaintSpec(
                    #     effect=eks.TaintEffect.NO_SCHEDULE,
                    #     key="",
                    #     value=""
                    #     )]
        )

        fargate1 = eks.FargateProfile(self, "fargate-group-1",
                    cluster=cluster,
                    selectors=[eks.Selector(namespace="default")],
                    fargate_profile_name="fargate-1",
                    vpc=vpc,
                    subnet_selection=ec2.SubnetType.PRIVATE_WITH_NAT
        )
     
        

        fargate2 = eks.FargateProfile(self, "fargate-group-2",
                    cluster=cluster,
                    selectors=[eks.Selector(namespace="fargate")],
                    fargate_profile_name="fargate-2",
                    vpc=vpc,
                    subnet_selection=ec2.SubnetType.PRIVATE_WITH_NAT,
        )


        # # node_role.node.add_dependency(master_role)
        # # cluster.node.add_dependency(node_role)
        # fargate1.node.add_dependency(cluster)
        # # nodegp.node.add_dependency(fargate1)
        # fargate2.node.add_dependency(nodegp)

        # self.fargate1.cfn_options.condition = CfnCondition(self, "CreateFargate",
        # Fn.condition_if("fargate", "true", "false")
        # )     

